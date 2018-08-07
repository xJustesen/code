#include "simulator.h"

/* Look up global variables (globalvars.h) */
extern default_random_engine generator;
extern normal_distribution<double> xdistro;
extern normal_distribution<double> ydistro;
extern uniform_int_distribution<int> hits_per_event;
extern normal_distribution<double> x_entry_angles;
extern normal_distribution<double> y_entry_angles;
extern uniform_real_distribution<double> R;

simulator::simulator(int N, vector<double> z, char const *run, vector<double> params, char const *filename){
  /* Simulation paramters */
  Nevents = N;  // number of simulated events
  zplanes = z;  // z-coordinates of mimosa detectors
  name = run; // name suffix for produced data-files
  beam_spatial_distro = (string) filename; // name of suffix of file containing beam's spaital distro.
  assert (!strcmp("amorphous", name) or !strcmp("aligned", name) or !strcmp("background", name));
  E = params[0];  // energy of beam [GeV]
  d_c = params[1];  // thickness of crystal target [micrometer]
  double mean_entry_angle_x = params[2],
         mean_entry_angle_y = params[3],
         dev_entry_angle_x = params[4],
         dev_entry_angle_y = params[5];

  conversions = 0;
  DATPATH = "/home/christian/Dropbox/speciale/data";  // path to save results

  /* Physics constants */
  q = -1.6021766208E-19; // charge of electron in Coulomb
  c = 299792458; // speed of light in vac. in m/s
  m = 9.10938356E-31; // electron/positron mass in kg

  /* Prepare vectors for photon, particle and mimosa data */
  particles.resize(Nevents);
  photons.resize(Nevents);
  mimosas.resize(6);
  for (int i = 0; i < 6; i++){
    mimosas[i].resize(5*Nevents);
  }

  if (!strcmp("aligned", name)){
    string aligned_crystal_sim = "sum_angles1mm40GeVelec.txt";
    load_doubles(aligned_crystal_sim, intensity_sum);

    intensity_sum.erase(intensity_sum.begin(), intensity_sum.begin() + 5);
    emitted_energies = linspace(0.0, E, intensity_sum.size());

    /* Calculate integral of energy. Used to determine photon emission */
    I_integral = 0;
    double dx = (emitted_energies[1] - emitted_energies[0]);
    for (size_t i = 1; i < intensity_sum.size(); i++){
      I_integral += (0.5 * dx * (intensity_sum[i-1] + intensity_sum[i]))/emitted_energies[i];
    }

    /* Do linear interpolation to obtain better energy resoultion */
    energies_interp = linspace(0.0, E, 2*intensity_sum.size());
    linterp(emitted_energies, intensity_sum, energies_interp, intensity_sum);

    /* Construct vector with intensity distribution for different points in space */
    make_intensity_distro(intensities, angles);
  }
  /* Make probability distributions and seed rng */
  x_entry_angles.param(normal_distribution<double>(mean_entry_angle_x, dev_entry_angle_x).param());
  y_entry_angles.param(normal_distribution<double>(mean_entry_angle_y, dev_entry_angle_y).param());
  xdistro.param(normal_distribution<double>(-1448.8971, 4028.8076).param());
  ydistro.param(normal_distribution<double>(1166.9424 , 1987.749).param());
  R.param(uniform_real_distribution<double>(0.0, 1.0).param());
  generator.seed(random_device{}());

  /* Report progress to terminal */
  cerr << "\nFinished initializing simulator class. Ready to simulate " << N << " events. Using " << name << " crystal.\n\n";
}

void simulator::load_doubles(string filename, vector<double> &data){
  ifstream datafile(filename);
  double val;
  if (datafile.is_open()){
    while (true){
      datafile >> val;
      if (datafile.eof()) break;
      data.push_back(val);
    }
    datafile.close();
  }
  else cout << "Unable to open file " << filename;
}

void simulator::print_hits(void){
  string filename = DATPATH + "/simulated_hits_coord_data" + name + ".txt";
  ofstream output (filename);
  for (size_t i = 0; i < mimosas.size(); i++){  // planes
    output << "## PLANE\t" << i << "\tHIT DATA\n"; // block header
    for (size_t j = 0; j < mimosas[i].size(); j++){ // events
      for (size_t k = 0; k < mimosas[i][j].size(); k++){ // hits
      output << mimosas[i][j][k][0] << ' ' << mimosas[i][j][k][1] << '\n';
      } // end hits
    } // end events
  } // end planes
}

void simulator::print_energy(void){
  string filename = DATPATH + "/photon_energy_sim_ " + name + ".txt";
  ofstream output (filename);
  for (size_t i = 0; i < energies.size(); i++){
    output << energies[i] << "\n";
  }
}

void simulator::generate_beam(void){
  /* Generate a beam-profile using measured data and store hits in Events */
  vector<double> x, y, xw, yw, a, xaw, yaw;
  string xdata_coords = "../beamParemters/xdat_" + beam_spatial_distro,
         ydata_coords = "../beamParemters/ydat_" + beam_spatial_distro,
         xdata_weights = "../beamParemters/xweight_" + beam_spatial_distro,
         ydata_weights = "../beamParemters/yweight_" + beam_spatial_distro,
         xangles_weights = "../beamParemters/angles_xweight_" + beam_spatial_distro,
         yangles_weights = "../beamParemters/angles_yweight_" + beam_spatial_distro,
         angles = "../beamParemters/angles.txt";

  load_doubles(xdata_coords, x);
  load_doubles(xdata_weights, xw);
  load_doubles(ydata_coords, y);
  load_doubles(ydata_weights, yw);
  load_doubles(xangles_weights, xaw);
  load_doubles(yangles_weights, yaw);
  load_doubles(angles, a);

  int hits_per_event = 5;
  for (int i = 0; i < Nevents; i++){
    particles[i].resize(hits_per_event);
    for (int j = 0; j < hits_per_event; j++){
      int xindx = select_member(x, xw);
      int yindx = select_member(y, yw);
      int xangleindx = select_member(a, xaw);
      int yangleindx = select_member(a, yaw);
      double xcoord = x[xindx];
      double ycoord = y[yindx];
      double xslope = a[xangleindx];
      double yslope = a[yangleindx];
      vector<double> hitdata = {xcoord, ycoord, zplanes[0], 0, q, E, xslope, yslope};  // x, y, z, plane, charge, energy of particle, xslope, yslope
      particles[i][j] = hitdata;
    }
  }
}

void simulator::propagate_particles(void){
  /* Propagates particles through the experiment. All radiation lengths are taken from PDG  */
  generate_beam();
  int total_emitted = 0, total_detected = 0;

  /* Radiation length of different materials. Used to calculate SAMS of particle. Units micro-meter */
  double X0_Si_amorph = 9.370E+04,
         X0_C_amorph = 21.35E+04,
         X0_C_gem = 12.13E+04,
         X0_He = 5.671E+09,
         X0_air = 3.039E+08,
         X0_Ta = 0.4094E+04,
         X0_tape = 19.63E+04,
         X0_Mylar =  28.54E+04;
  double d_f = 200.0; // thickness of Tantalum foil (micro-meter)

  // #pragma omp parallel for
  double start_time = omp_get_wtime();
  double T = 0;
  for (int i = 0; i < Nevents; i++){
    int emitted = 0;
    // amorph_crystal(i, emitted, X0_Si_amorph, 1.0E+03, 300);

    /* First Mylar window. No multiple scattering since we take the beam profile from the data, where multiple scattering is intrisincly included */
    // amorph_crystal(i, emitted, X0_Mylar, 50.0);
    // pair_production(i, 50.0, X0_Mylar);
    /* MIMOSA 1 detector */
    // amorph_material(i, emitted, X0_tape, 50.0, 50.0, 15);
    SA_mult_scat(0, i, X0_tape, 50.0);
    mimosa_detector(0, i, total_detected);
    // amorph_material(i, emitted, X0_Si_amorph, 100.0, 50.0, 15);
    SA_mult_scat(0.003, i, X0_Si_amorph, 100.0);

    /* Helium between M1 and M2 */
    // amorph_material(i, emitted, X0_He, zplanes[1] - 50.0, zplanes[1] - 150.0, 100);
    SA_mult_scat(zplanes[1] - zplanes[0], i,  X0_He, zplanes[1] - 50.0);

    /* MIMOSA 2 detector */
    // amorph_material(i, emitted, X0_tape, zplanes[1], 50.0, 15);
    SA_mult_scat(50.0, i, X0_tape, zplanes[1]);
    mimosa_detector(1, i, total_detected);
    // amorph_material(i, emitted, X0_Si_amorph, zplanes[1] + 50.0, 50.0, 15);
    SA_mult_scat(0.003, i, X0_Si_amorph, zplanes[1] + 50.0);
    /* Last mylar window He encasing */
    // amorph_material(i, emitted, X0_Mylar, zplanes[1] + 100.0, 50.0, 15);
    SA_mult_scat(50.0, i, X0_Mylar, zplanes[1] + 100.0);
    // amorph_material(i, emitted, X0_air, 2060E+03, 227600, 100);
    SA_mult_scat(200.0, i, X0_air, 2060E+03);
    /* Traverse crystal */
    if (!strcmp("amorphous", name)){
      amorph_material(i, emitted, X0_C_amorph, 2060E+03 + d_c, d_c, 0.3 * d_c);
      SA_mult_scat(d_c, i, X0_C_amorph, 2060E+03 + d_c);
    } else if (!strcmp("aligned", name)){
      aligned_crystal(i, emitted);
      SA_mult_scat(d_c, i, X0_C_gem, 2060E+03);
      pair_production(i, d_c, X0_C_gem, 300);
    }
    // amorph_material(i, emitted, X0_air, 2310E+03, 250E+03, 15);
    SA_mult_scat(1, i, X0_air, 2310.0E+03);

    /* Traverse Scintilators */
    // amorph_material(i, emitted, X0_Si_amorph, 2310E+03 + 1.0E+03, 1.0E+03, 15);
    SA_mult_scat(1.0E+03, i, X0_Si_amorph, 2310E+03 + 1.0E+03);

    /* Air between S2 and vacuum tube */
    // amorph_material(i, emitted, X0_air, 2311E+03  + 1.5E+06, 1.5E+06, 15);
    SA_mult_scat(1.5E+06, i, X0_air, 2310E+03  + 1.5E+06);
    /* Traverse vacuum chamber and MBPL magnet */
    // amorph_material(i, emitted, X0_Mylar, 2310E+03  + 1.5E+06 + 120.0, 120.0, 15);
    SA_mult_scat(120.0, i, X0_Mylar, 2310E+03  + 1.5E+06 + 120.0);
    // amorph_material(i, emitted, X0_tape, 2310E+03 + 1.5E+06 + 120.0 + 100.0, 100.0, 15);
    SA_mult_scat(100.0, i, X0_tape, 2310E+03 + 1.5E+06 + 120.0 + 100.0);
    // project_particle(particles, zplanes[2], i);
    MBPL_magnet(i);
    // pair_production(i, 120.0, X0_Mylar, 30);
    SA_mult_scat(120, i, X0_Mylar, 2310E+03 + 1.5E+06 + 120.0 + 100.0 + 120.0);
    // amorph_material(i, emitted, X0_tape, 2310E+03 + 1.5E+06 + 120.0 + 100.0 + 120.0 + 100.0, 100.0, 15);
    SA_mult_scat(100.0, i, X0_tape, 2310E+03 + 1.5E+06 + 120.0 + 100.0 + 120.0 + 100.0);
    //
    // /* Air between vacuum tube and M3 */
    // pair_production(i, 1500.0E+03, X0_air, 100);
    SA_mult_scat(100.0, i, X0_air, zplanes[2] - d_f);
    /* Traverse converter foil */
    project_particle(photons, zplanes[2] - d_f, i);
    converter_foil(i, d_f, X0_Ta, 300);
    // SA_mult_scat(i, d_f, X0_Ta, zplanes[2]);
    /* MIMOSA 3 detector */
    // amorph_material(i, emitted, X0_tape, zplanes[2] + 50.0, 50.0, 15);
    SA_mult_scat(50.0, i, X0_tape, zplanes[2] + 50.0);
    mimosa_detector(2, i, total_detected);
    // amorph_material(i, emitted, X0_Si_amorph, zplanes[2] + 100.0, 50.0, 15);
    SA_mult_scat(0.003, i, 9.370E+04 , zplanes[2] + 100.0);

    /* Air between M3 and M4 */
    // amorph_material(i, emitted, X0_air, zplanes[3], zplanes[3] - zplanes[2]);
    SA_mult_scat(zplanes[3] - zplanes[2], i, X0_air, zplanes[3]);
    /* MIMOSA 4 detector */
    // amorph_material(i, emitted, X0_tape, zplanes[3] + 50.0, 50.0, 15);
    SA_mult_scat(50.0, i, X0_tape, zplanes[3] + 50.0);
    mimosa_detector(3, i, total_detected);
    // amorph_material(i, emitted, X0_Si_amorph, zplanes[3] + 100.0, 50.0, 15);
    SA_mult_scat(0.003, i, 9.370E+04, zplanes[3] + 100.0);
    /* Air between M4 and middle of MIMOSA magnet */
    // amorph_material(i, emitted, X0_air, (zplanes[4] + zplanes[3])/2.0,(zplanes[4] - zplanes[3])/2.0, 15);
    SA_mult_scat((zplanes[4] - zplanes[3])/2.0, i, X0_air, (zplanes[4] + zplanes[3])/2.0);
    /* MIMOSA magnet */
    mimosa_magnet(i);

    /* Air between middle of MIMOSA magnet and M5 */
    // amorph_material(i, emitted, X0_air, zplanes[4], (zplanes[4] - zplanes[3])/2.0, 15);
    SA_mult_scat((zplanes[4] - zplanes[3])/2.0, i, X0_air, zplanes[4]);
    /* MIMOSA 5 detector */
    // amorph_material(i, emitted, X0_tape, zplanes[4] + 50.0, 50.0, 15);
    SA_mult_scat(50.0, i, X0_tape, zplanes[4] + 50.0);
    mimosa_detector(4, i, total_detected);
    // amorph_material(i, emitted, X0_Si_amorph, zplanes[4] + 100.0, 50.0, 15);
    SA_mult_scat(0.003, i, 9.370E+04, zplanes[4] + 100.0);
    /* Air between MIMOSA 5 and MIMOSA 6 detectors */
    // amorph_material(i, emitted, X0_air, zplanes[5], zplanes[5] - zplanes[4]);
    SA_mult_scat(zplanes[5] - zplanes[4], i, X0_air, zplanes[5]);
    /* MIMOSA 6 detector */
    // amorph_material(i, emitted, X0_tape, zplanes[5] + 50.0, 50.0, 15);
    SA_mult_scat(50.0, i, X0_tape, zplanes[5] + 50.0);
    mimosa_detector(5, i, total_detected);
    total_emitted += emitted;

    if ( (i+1) % 100001 == 0){
      double dt = omp_get_wtime() - start_time;
      T += dt;
      cerr << "Progress :\t" << floor(100 * double(i)/(double)Nevents) << "%" << "\tTime used for previous 10000 events:\t" << dt << "\tTotal time elapsed :\t" << T << "\tEstimated time remaining :\t" << dt * (double)Nevents/100001.00 - T << "\n";
      start_time = omp_get_wtime();
    }
  }
  /* Report progress to terminal */
  cerr << "\nTotal photons emitted : " << total_emitted << "\n";
  cerr << "Total conversions : " << conversions << "\n";
}

void simulator::amorph_material(int eventno, int &emitted, double X0, double z, double L, int N_slices){
  double Emin = 2.0*0.5109989461E-03;
  vector<double> xcrystal = {-6000.0, -470.0, 6000.0};
  vector<double> ycrystal = {-3500.0, 3800.0, -3500.0};
  double dl = L/(double)N_slices;
  for (size_t hitno = 0; hitno < particles[eventno].size(); hitno++){

    double dldL = (z - particles[eventno][hitno][2])/L;
    int no_slices = dldL * N_slices;
    // cerr << z << "\t" << particles[eventno][hitno][2] << "\t" << L << "\t" << dldL << "\t" << N_slices << "\t" << no_slices << "\n";
    bool inside_bounds = isInside(3, xcrystal, ycrystal, particles[eventno][hitno][0], particles[eventno][hitno][1]);

    if ((X0 == 21.35E+04 and inside_bounds) or X0 != 21.35E+04){
      for (int i = 0; i < no_slices; i++) {
        double Epart = particles[eventno][hitno][5];
        // double dl = (z - particles[eventno][hitno][2])/double(no_slices);
        // cerr << eventno << "\t" << z << "\t" << particles[eventno][hitno][2] << "\t" << dl << "\t";
        /* Determine if photon is emitted */
        bool emission = photon_emitted_amorph(dl, X0, Epart);
        /* If photon is emitted update "photons" array and particles array */

        if (emission and Epart > Emin) {
          emitted++;
          /* Determine photon energy */
          double randno = R(generator);
          double norm = 4.0/3.0 * log(Epart/Emin) - 4.0/(3.0*Epart) * (Epart - Emin) + 1.0/(2.0*Epart*Epart) * (Epart*Epart - Emin*Emin);
          function<double(vec)> energy =  [randno, Epart, norm] (vec x) {return photonic_energy_distribution(x, randno, Epart, norm);};  // make lambda-function in order to use same randno during iteration
          vec sc1 = {0.1}; vec sc2 = {5.0}; vector<vec> initial_simplex = {sc1, sc2};  // initial simplex for Nelder-Mead. The initial guess is hugely important for convergence
          vec photon_energy = simplex_NM(energy, initial_simplex, 1.0E-08);  // solve for energy using Nelder-Mead simplex.
          energies.push_back(photon_energy(0));

          /* Determine direction of photon */
          double gamma = particles[eventno][hitno][5]/(m*c*c);
          uniform_real_distribution<double> defl_angle(-1.0/gamma, 1.0/gamma);

          // double l = ((double)no_slices - (double)i + 1.0)/((double)no_slices) * L;

          /* Update particles and photons vectors */
          vector<double> photon = particles[eventno][hitno];
          photon[2] += (1 + i) * dl; // z-val
          photon[4] = 0.0;  // charge
          photon[5] = photon_energy(0);
          double dx = defl_angle(generator);
          double dy = sqrt(1.0/(gamma*gamma) - dx*dx);
          photon[6] += dx;
          photon[7] += dy;
          particles[eventno][hitno][5] -= photon_energy(0); // GLOBAL PARTILCES VECTOR
          photons[eventno].push_back(photon);

          /* Determine if a conversion happens */
          int indx = 0;
          while (indx < no_slices - i - 1){
            bool conversion = pair_produced(dl, X0);

            if (conversion and photon_energy(0) > Emin) {
              /* Calculate energy gained by e+/e- pair */
              double electron_energy = R(generator);  // random number for the inverse transform sampling in "electronic_energy_distribution"
              electronic_energy_distribution(electron_energy); // the fractional electron energy, ie E_e-/ E_photon
              electron_energy *= photon_energy(0);
              double positron_energy = photon_energy(0) - electron_energy; // energy conservation

              /* Calculate deflection of e+/e- pair */
              double electron_defl = Borsollini(electron_energy, positron_energy, photon_energy(0)); // deflection angle based on approximated Borsollini distribution
              double positron_defl = electron_energy * electron_defl / positron_energy; // conservation of momentum

              /* Add e+/e- pair to "particles" array */
              vector<double> electron = photons[eventno].back();
              electron[2] += dl * (indx + 1);
              electron[4] = (-1.0)*q;
              electron[5] = electron_energy;
              electron[6] += electron_defl;
              vector<double> positron = photons[eventno].back();
              positron[2] += dl * (indx + 1);
              positron[4] = q;
              positron[5] = positron_energy;
              positron[6] += positron_defl;
              particles[eventno].push_back(positron); // GLOBAL particles vector
              particles[eventno].push_back(electron); // GLOBAL particles vector
              photons[eventno].pop_back();
              break;
            }
            indx++;
          }
        }
      }
    }
  }
}

void simulator::converter_foil(int eventno, double d_f, double X0, int no_slices){
  double Emin = 2*0.5109989461E-03;  // 2 * electron mass in GeV
  double  x1 = -1.126E+04,
          x2 = -1.136E+04,
          x3 = 0.9363E+04,
          x4 = 0.9399E+04,
          y1 = -0.8661E+04,
          y2 = 0.1654E+04,
          y3 = 0.1924E+04,
          y4 = -0.8373E+04;
  vector<double> xbounds = {x1, x2, x3, x4};  // xcoords of corners of M3
  vector<double> ybounds = {y1, y2, y3, y4};  // ycoords of corners of M3

  for (size_t i = 0; i < photons[eventno].size(); i++){
    bool inside_bounds = isInside(4, xbounds, ybounds, photons[eventno][i][0], photons[eventno][i][1]);
    if (!inside_bounds) break;
    double dldL = (zplanes[2] - photons[eventno][i][2])/d_f;
    int N_slices = dldL * no_slices;  // remaining number of slices
    // cerr << N_slices << "\n";
    for (int j = 0; j < N_slices; j++){
      /* Determine if a conversion happens */
      double randno = R(generator);
      if (randno < 0.038/(double)no_slices and photons[eventno][i][5] > Emin){
        conversions++;

        /* Calculate energy gained by e+/e- pair */
        double photon_energy = photons[eventno][i][5];
        energies.push_back(photon_energy);
        double electron_energy = R(generator);  // random number for the inverse transform sampling in "electronic_energy_distribution"
        electronic_energy_distribution(electron_energy); // the fractional electron energy, ie E_e-/ E_photon
        electron_energy *= photon_energy;
        double positron_energy = photon_energy - electron_energy; // energy conservation
        photons[eventno][i][5] -= electron_energy + positron_energy;

        /* Calculate deflection of e+/e- pair */
        double electron_defl = Borsollini(electron_energy, positron_energy, photon_energy); // deflection angle based on approximated Borsollini distribution
        double positron_defl = electron_energy * electron_defl / positron_energy; // conservation of momentum

        /* Add e+/e- pair to "particles" array */
        vector<double> electron = photons[eventno][i];
        electron[2] += (d_f)/(double)N_slices * (j + 1);
        electron[4] = (-1.0)*q;
        electron[5] = electron_energy;
        electron[6] += electron_defl;

        vector<double> positron = photons[eventno][i];
        positron[2] += (d_f)/(double)N_slices * (j + 1);
        positron[4] = q;
        positron[5] = positron_energy;
        positron[6] += positron_defl;

        particles[eventno].push_back(positron);
        particles[eventno].push_back(electron);

        photons[eventno].erase(photons[eventno].begin() + i); // remove i'th photon since it converted

        double l = ((double)N_slices - (double)j + 1.0)/((double)N_slices) * d_f;
        int sz = particles[eventno].size();

        /* Iterate over the pair*/
        for (int jj = 0; jj < 2; jj++){
          /* Brehmstrahlung */
          double randno = R(generator);
          double Epart = particles[eventno][sz - 1 - jj][5];
          bool emission = photon_emitted_amorph(d_f/(double)N_slices, X0, Epart);
          if (emission){
            double norm = 4.0/3.0 * log(Epart/Emin) - 4.0/(3.0*Epart) * (Epart - Emin) + 1.0/(2.0*Epart*Epart) * (Epart*Epart - Emin*Emin);
            function<double(vec)> energy =  [randno, Epart, norm] (vec x) {return photonic_energy_distribution(x, randno, Epart, norm);};  // make lambda-function in order to use same randno during iteration
            vec sc1 = {0.1}; vec sc2 = {5.0}; vector<vec> initial_simplex = {sc1, sc2};  // initial simplex for Nelder-Mead. The initial guess is hugely important for convergence
            vec photon_energy = simplex_NM(energy, initial_simplex, 1.0E-08);  // solve for energy using Nelder-Mead simplex.

            /* Determine deflection of photon */
            double gamma = particles[eventno][sz - 1 - jj][5]/(m*c*c);
            uniform_real_distribution<double> defl_angle(-1.0/gamma, 1.0/gamma);

            /* Update particles and photons vectors */
            vector<double> photon = particles[eventno][sz - 1 - jj];
            photon[2] += l - d_f; // z-val
            photon[4] = 0.0;  // charge
            photon[5] = photon_energy(0);
            double dx = defl_angle(generator);
            double dy = sqrt(1.0/(gamma*gamma) - dx*dx);
            photon[6] += dx;
            photon[7] += dy;
            particles[eventno][sz - 1 - jj][5] -= photon_energy(0); // energy lost by particle as it emits photon
            particles[eventno][sz - 1 - jj][2] = zplanes[2];
            photons[eventno].push_back(photon);
          }
        }
        i -= 1; // subtract 1 from iterator since we removed element
        break;
      }
    }
  }
}

void simulator::MBPL_magnet(int eventno){
  particles[eventno].clear(); // the MPBL magnet removes all particles
}

void simulator::amorph_crystal(int eventno, int &emitted, double X0, double d, int no_slices){
  /* Simulate a particle travelling through an amorphous crystal.
     Multiple scattering is taken into account in the "propagte particles" function.
  */
  vector<double> xcrystal = {-6.7E+03, -2.0E+02, 6.5E+03, 4.50E+02, -4.7E+03};
  vector<double> ycrystal = {-4.72E+03, 2.0E+03, -4.72E+03, -8.50E+03, -8.50E+03};
  normal_distribution<double> distribution(0.0, 1.0);
  double dl = d/(double)no_slices;
  double Emin = 2*0.5109989461E-03;  // 2 * electron mass in GeV

  for (size_t hitno = 0; hitno < particles[eventno].size(); hitno++){
    /* Check if particle is going to hit crystal */
    bool inside_bounds = isInside(5, xcrystal, ycrystal, particles[eventno][hitno][0], particles[eventno][hitno][1]);

    if ((X0 == 21.35E+04 and inside_bounds) or X0 != 21.35E+04) {
      for (int i = 0; i < no_slices; i ++){
        double Epart = particles[eventno][hitno][5];
        if (Epart < Emin) break;
        /* Determine if photon is emitted */
        bool emission = photon_emitted_amorph(dl, X0, Epart);

        /* If photon is emitted update "photons" array and particles array */
        if (emission){
          emitted++;

          /* Determine photon energy */
          double randno = R(generator);
          Epart = particles[eventno][hitno][5];
          double norm = 4.0/3.0 * log(Epart/Emin) - 4.0/(3.0*Epart) * (Epart - Emin) + 1.0/(2.0*Epart*Epart) * (Epart*Epart - Emin*Emin);
          function<double(vec)> energy =  [randno, Epart, norm] (vec x) {return photonic_energy_distribution(x, randno, Epart, norm);};  // make lambda-function in order to use same randno during iteration
          vec sc1 = {0.1}; vec sc2 = {5.0}; vector<vec> initial_simplex = {sc1, sc2};  // initial simplex for Nelder-Mead. The initial guess is hugely important for convergence
          vec photon_energy = simplex_NM(energy, initial_simplex, 1.0E-08);  // solve for energy using Nelder-Mead simplex.

          /* Determine direction of photon */
          double gamma = particles[eventno][hitno][5]/(m*c*c);
          uniform_real_distribution<double> defl_angle(-1.0/gamma, 1.0/gamma);

          /* Update particles and photons vectors */
          vector<double> photon = particles[eventno][hitno];
          photon[4] = 0.0;  // charge
          photon[5] = photon_energy(0);
          double dx = defl_angle(generator);
          double dy = sqrt(1.0/(gamma*gamma) - dx*dx);
          photon[6] += dx;
          photon[7] += dy;
          particles[eventno][hitno][5] -= photon_energy(0); // energy lost by particle as it emits photon
          photons[eventno].push_back(photon);
        }
      }
    }
  }
}

void simulator::make_intensity_distro(vector<vector<double>> &intensities, vector<vector<double>> &angles){
  /* Load data of spatial distribution of energy into matrix */
  mat intensity_spatial; intensity_spatial.load("sum_initials1mm40GeVelec.txt");

  /* Convert directional vectors into angles (SAA of directional cosine) */
  angles.resize(intensity_spatial.n_cols);
  for (size_t i = 0; i < intensity_spatial.n_cols; i++){
    angles[i].resize(2);
    angles[i][0] = acos(intensity_spatial(0, i));
    angles[i][1] = acos(intensity_spatial(1, i));
  }

  /* Define vector with intensities */
  intensity_spatial.shed_rows(0, 4);
  intensities.resize(energies_interp.size());
  for (size_t i = 0; i < intensities.size(); i++) intensities[i].resize(intensity_spatial.n_cols);
  vector<double> intensities_i(intensity_spatial.n_rows);

  /* Calculate spatial intensity distro. for every energy */
  for (size_t j = 0; j < energies_interp.size(); j++){
    for (size_t i = 0; i < intensity_spatial.n_cols; i++){

      /* Extract column i from intensity_spatial matrix */
      for (size_t k = 0; k < intensity_spatial.n_rows; k++){
        intensities_i[k] = intensity_spatial(k, i);
      }

      /* Do linear interpolation to increase energy/intensity resoultion */
      linterp(emitted_energies, intensities_i, energies_interp, intensities_i);

      /* Fill "intensities" vector. The j'th entry corresponds to given energy, the i'th entry is the intensity at the angle corresponding to the i'th column in "sum_initials1mm40GeVelec" vector */
      intensities[j][i] = intensities_i[j];
    }
  }
}

bool simulator::photon_emitted_aligned(double N){
  double randno = R(generator);
  return randno < I_integral/N;
}

void simulator::aligned_crystal(int eventno, int &emitted){
  /* Simulate a particle travelling through an aligned crystal.
     Multiple scattering is taken into account in the "propagte particles" function.
   */
  int no_slices = 15;
  vector<double> angle_indx = linspace(0.0, angles.size()-1, angles.size());
  for (size_t hitno = 0; hitno < particles[eventno].size(); hitno++){
    for (int i = 0; i < no_slices; i++){
      /* Determine if photon is emit\ed */
      bool emission = photon_emitted_aligned(no_slices);

      /* If photon is emitted update "photons" array and particles array */
      if (emission){
        emitted++;

        /* Determine which energy photon is emitted with */
        int E_indx = select_member(energies_interp, intensity_sum);

        /* Determine where in space photon is emitted */
        int x_indx = select_member(angle_indx, intensities[E_indx]);

        /* Determine deflection of photon */
        double gamma = particles[eventno][hitno][5]/(m*c*c);
        uniform_real_distribution<double> defl_angle(-1.0/gamma, 1.0/gamma);

        /* Add photon to "photons" vector */
        vector<double> photon = particles[eventno][hitno];
        photon[4] = 0.0;  // charge
        photon[5] = energies_interp[E_indx];
        double dx = angles[(int)(angle_indx[x_indx])][0] - M_PI/2.0;
        double dy = angles[(int)(angle_indx[x_indx])][1] - M_PI/2.0;
        photon[6] += dx;
        photon[7] += dy;
        particles[eventno][hitno][5] -= energies_interp[E_indx]; // energy lost by particle as it emits photon
        photons[eventno].push_back(photon);
      }
      /* Break loop if particle converts to photon which does not have enough energy to convert into e-/e+ pair */
      if (particles[eventno][hitno][5] < 2*0.5109989461E-03){
        break;
      }
    }
  }
}

void simulator::mimosa_detector(int planeno, int eventno, int &detections){
  /* Define mimosa parameters */
  double x1 = 0.0, x2 = 0.0, x3 = 0.0, x4 = 0.0, y1 = 0.0, y2 = 0.0, y3 = 0.0, y4 = 0.0;
  switch (planeno){
    case 0: x1 = -1.059E+04;
            x2 = -1.059E+04;
            x3 = 1.059E+04;
            x4 = 1.059E+04;
            y1 = -0.5290E+04;
            y2 = 0.5273E+04;
            y3 = 0.5273E+04;
            y4 = -0.5290E+04;
            break;
    case 1: x1 = -1.059E+04;
            x2 = -1.059E+04;
            x3 = 1.059E+04;
            x4 = 1.059E+04;
            y1 = -0.5290E+04;
            y2 = 0.5273E+04;
            y3 = 0.5273E+04;
            y4 = -0.5290E+04;
            break;
   case 2: x1 = -1.126E+04;
           x2 = -1.136E+04;
           x3 = 0.9363E+04;
           x4 = 0.9399E+04;
           y1 = -0.8661E+04;
           y2 = 0.1654E+04;
           y3 = 0.1924E+04;
           y4 = -0.8373E+04;
           break;
   case 3: x1 = -1.100E+04;
           x2 = -1.104E+04;
           x3 = 0.9700E+04;
           x4 = 0.9730E+04;
           y1 = -0.8550E+04;
           y2 = 0.1682E+04;
           y3 = 0.1891E+04;
           y4 = -0.8342E+04;
           break;
   case 4: x1 = -1.142E+04;
           x2 = -1.149E+04;
           x3 = 0.9584E+04;
           x4 = 0.9694E+04;
           y1 = -0.8140E+04;
           y2 = 0.2231E+04;
           y3 = 0.2740E+04;
           y4 = -0.7872E+04;
           break;
   case 5: x1 = -1.245E+04;
           x2 = -1.241E+04;
           x3 = 0.8619E+04;
           x4 = 0.8759E+04;
           y1 = -0.7999E+04;
           y2 = 0.2374E+04;
           y3 = 0.2764E+04;
           y4 = -0.7868E+04;
           break;
  }
  vector<double> xbounds = {x1, x2, x3, x4};  // xcoords of corners
  vector<double> ybounds = {y1, y2, y3, y4};  // ycoords of corners
  mimosa_res = 50.0; // spatial resoultion of mimosa detector (micro-m) (smaller = better res.)

  /* Take into account detector resoultion by adding a random (Dx, Dy) displacement between -4 -> 4 micro-meter */
  normal_distribution<double> distribution(0.0, 4.0);
  for (size_t hitno = 0; hitno < particles[eventno].size(); hitno++){
    double Dx = distribution(generator);
    double Dy = distribution(generator);

    /* Check if particle is within physical boundaries of detector.*/
    bool inside_bounds = isInside(4, xbounds, ybounds, particles[eventno][hitno][0], particles[eventno][hitno][1]);
    if (inside_bounds){
      /* Combine neighbor-hits into single hit if they are closer than detectors resoultion */
      if (mimosas[planeno][eventno].size() > 0){
        double dist = calc_dist(particles[eventno][hitno][0] + Dx, particles[eventno][hitno][1] + Dx, mimosas[planeno][eventno][0][0], mimosas[planeno][eventno][0][1]);

        /* Save hit in "mimosas" array. This array has the same structure and contains equivalent data as the "hitcoords" array in the "analyser" class */
        if (dist > mimosa_res){
          mimosas[planeno][eventno].push_back({particles[eventno][hitno][0] + Dx, particles[eventno][hitno][1] + Dx});
        }
        /* The distance is shorter than detector resolution, so we combine two hits. This is equivalent to moving the previously recorded hit by half the seperation */
        else {
          double dx = mimosas[planeno][eventno][0][0] - particles[eventno][hitno][0] - Dx;
          double dy = mimosas[planeno][eventno][0][1] - particles[eventno][hitno][1] - Dx;
          mimosas[planeno][eventno][0][0] += dx/2.0;
          mimosas[planeno][eventno][0][1] += dy/2.0;
        }
      }
      /* If there are no previous hits in detector simply add the hit to "mimoas" array */
      else {
        mimosas[planeno][eventno].push_back({particles[eventno][hitno][0] + Dx, particles[eventno][hitno][1] + Dy});
      }
    }
  }
}

double simulator::calc_dist(double x0, double y0, double x1,double y1){
  return sqrt(pow(x1 - x0, 2) + pow(y1 - y0, 2));
}

void simulator::project_particle(vector<vector<vector<double>>> &particletype, double zcoord, int eventno){
  for (size_t hitno = 0; hitno < particletype[eventno].size(); hitno++){
    double dx = (zcoord - particletype[eventno][hitno][2]) *  particletype[eventno][hitno][6];
    double dy = (zcoord - particletype[eventno][hitno][2]) *  particletype[eventno][hitno][7];
    particletype[eventno][hitno][0] += dx;
    particletype[eventno][hitno][1] += dy;
    particletype[eventno][hitno][2] = zcoord;
  }
}

void simulator::SA_mult_scat(double d, int i, double X0, double zcoord){
  /* (i,j) : (eventno, hitno). The following formulae taken from PDG ch. 32, 2014 (particles through matter) */
  // normal_distribution<double> distribution(0.0, 1.0);
  for (size_t j = 0; j < particles[i].size(); j++){
    double l = zcoord - particles[i][j][2];
    // cerr << l << "\t" << zcoord << "\t" << particles[i][j][2] << "\n";
    for (int k = 0; k < 2; k++){
      double z1 = R(generator);
      double z2 = R(generator);
      double z = particles[i][j][4]/q;
      double theta0 = z * 0.0136/particles[i][j][5] * sqrt(l/X0) * (1 + 0.038 * log(l/X0));
      double dy = (z1*l*theta0)/sqrt(12) +  (z2*l*theta0)/2;
      double dtheta0 = z2 * theta0;
      particles[i][j][k] += dy + l * particles[i][j][6+k]; // total (x/y) displacement
      particles[i][j][k+6] += dtheta0; // xslope/yslope
    }
    particles[i][j][2] = zcoord;
  }
}

void simulator::mimosa_magnet(int eventno){
    /* Calculate the deflection of a charged particle traversing the mimosa magnet. Magnet only deflects in x-direction. */
    double L = 0.15; // length traveled through Mimosa magnet in m
    double B = 0.12; // strength of magnetic field in T
    for (size_t hitno = 0; hitno < particles[eventno].size(); hitno++){
      double dx;
      if (particles[eventno][hitno][4] > 0) dx = L*B*0.299792458/(particles[eventno][hitno][5]);
      else dx = (-1.0) * L*B*0.299792458/(particles[eventno][hitno][5]);
      particles[eventno][hitno][6] += dx; // update direction of particle
  }
}

double simulator::Borsollini(double E1, double E2, double E_phot){
  /* Approximated (SAA) Borsollini opening angle of produced electron (1) positron (2) pair */
  double u1 = R(generator), u2 = R(generator);
  double nu0 = E_phot*m*c/(E1*E2);
  double nu = nu0*(sqrt(1.0/(1.0 - u1) - 1.0) + 0.70*u2);
  double phi1 = nu/(E1/E2 + 1 - nu*nu/4); // deflection of particle 1
  return phi1;
}

void simulator::pair_production(int eventno, double d_f, double X0, int N_slices){
  for (size_t i = 0; i < photons[eventno].size(); i++){
    /* Break loop if photon does not have enough energy to convert into e-/e+ pair */
    if (photons[eventno][i][5] < 2*0.5109989461E-03){
      break;
    }

    for (int j = 0; j < N_slices; j++){
      /* Determine if a conversion happens */
      bool conversion = pair_produced(d_f/(double)N_slices, X0);

      if (conversion){
        // conversions++;

        /* Calculate energy gained by e+/e- pair */
        double photon_energy = photons[eventno][i][5];
        energies.push_back(photon_energy);
        double electron_energy = R(generator);  // random number for the inverse transform sampling in "electronic_energy_distribution"
        electronic_energy_distribution(electron_energy); // the fractional electron energy, ie E_e-/ E_photon
        electron_energy *= photon_energy;
        double positron_energy = photon_energy - electron_energy; // energy conservation

        /* Calculate deflection of e+/e- pair */
        double electron_defl = Borsollini(electron_energy, positron_energy, photon_energy); // deflection angle based on approximated Borsollini distribution
        double positron_defl = electron_energy * electron_defl / positron_energy; // conservation of momentum

        /* Add e+/e- pair to "particles" array */
        vector<double> electron = photons[eventno][i];
        electron[2] += (d_f)/(double)N_slices * (j + 1);
        electron[4] = (-1.0)*q;
        electron[5] = electron_energy;
        electron[6] += electron_defl;

        vector<double> positron = photons[eventno][i];
        positron[2] += (d_f)/(double)N_slices * (j + 1);
        positron[4] = q;
        positron[5] = positron_energy;
        positron[6] += positron_defl;

        particles[eventno].push_back(positron);
        particles[eventno].push_back(electron);

        /* Remove photon since it has converted */
        photons[eventno].erase(photons[eventno].begin() + i);

        /* Multiple scattering of electron + positron */
        double l = ((double)N_slices - (double)j)/((double)N_slices) * d_f;
        int sz = particles[eventno].size();
        normal_distribution<double> distribution(0.0, 1.0);

        // for (int k = 0; k < 2; k++){
        //   double z1 = distribution(generator);
        //   double z2 = distribution(generator);
        //   double z = particles[eventno][sz - 1][4]/q;
        //   double energy = particles[eventno][sz - 1][5] * 1.6021766E-10;  // energy in Joule
        //   double theta0 = 2.179E-12/(energy) * z * sqrt(l/X0) * (1 + 0.038*log(l/X0));
        //   double yplane = (z1*l*theta0)/sqrt(12) +  (z2*l*theta0)/2;
        //   double thetaplane = z2 * theta0;
        //   particles[eventno][sz - 1][k] += yplane + l * particles[eventno][sz - 1][6+k]; // total (x/y) displacement
        //   particles[eventno][sz - 1][k+6] += thetaplane; // xslope/yslope
        // }
        //
        // for (int k = 0; k < 2; k++){
        //   double z1 = distribution(generator);
        //   double z2 = distribution(generator);
        //   double z = particles[eventno][sz - 2][4]/q;
        //   double energy = particles[eventno][sz - 2][5] * 1.6021766E-10;  // energy in Joule
        //   double theta0 = 2.179E-12/(energy) * z * sqrt(l/X0) * (1 + 0.038*log(l/X0));
        //   double yplane = (z1*l*theta0)/sqrt(12) +  (z2*l*theta0)/2;
        //   double thetaplane = z2 * theta0;
        //   particles[eventno][sz - 2][k] += yplane + l * particles[eventno][sz - 2][6+k]; // total (x/y) displacement
        //   particles[eventno][sz - 2][k+6] += thetaplane; // xslope/yslope
        // }
        i -= 1;
        break;
      }
    }
  }
}

bool simulator::pair_produced(double l, double X0_f){
  /* See http://pdg.lbl.gov/2014/reviews/rpp2014-rev-passage-particles-matter.pdf for formulae and constants */
  double randno = R(generator); // random double between 0, 1 used to determine if a pair is produced
  return randno < (7.0*l)/(9.0*X0_f);
}

bool simulator::photon_emitted_amorph(double l, double X0, double E){
  /* Calcualte wheter or not a photon is emitted when traveling through an amorphous crystal. */
  double randno = R(generator); // random double between 0, 1 used to determine if a pair is produced
  double Emin = 2*0.5109989461E-03; // 2 * Electron mass in GeV must be the minimum energy of photon, since we cannot observe lower energy photons anyway
  double P = (4.0*l)/(3.0*X0) * (log(E/Emin) - (E - Emin)/E  + (3.0/8.0) * (1.0 - Emin*Emin/(E*E)));  // BH-cross section * crystal length
  // cerr << E << "\t" << l << "\t" << P << "\t" << randno << "\n";
  return randno < P;
}

void simulator::electronic_energy_distribution(double &r){
  /* Analytical solution to CDF(x) = r (see Flohr's thesis) integrated and solved 3rd order poly. equation (2.58)
      r : random number */
  r = 0.25*(1.5874*pow(sqrt(196.0*r*r - 196.0*r + 81.0) + 14*r - 7.0, 1.0/3.0) - 5.03968/pow(sqrt(196.0*r*r - 196.0*r + 81.0) + 14.0*r - 7.0, 1.0/3.0) + 2.0);
}

double simulator::photonic_energy_distribution(vec x, double r, double Eb,double norm){
  /* This function is minimized to determine the photon energy.
  The Bethe-Heitler cross section as presented in Flohr's thesis, should be solved using inverse transform sampling with a Nelder-Mead simplex solver. The equation is therefore normalized to ensure the probability distro. is betwen (0, 1)
      x   : solution, ie E_e- / E_photon
      r   : random number betwenn (0, 1)
      Eb  : beam energy
  */
  double Emin = 2.0 * 0.5109989461E-3; // 2 * electron mass GeV
  return x(0) > 0 ? abs((4.0/3.0 * log(x(0)/Emin) - 4.0/3.0 * (x(0) - Emin)/Eb + 1.0/(2.0*Eb*Eb) * (x(0)*x(0) - Emin*Emin)) - r*norm) : abs((4.0/3.0 * log(abs(x(0))/Emin) - 4.0/3.0 * (abs(x(0)) - Emin)/Eb + 1.0/(2.0*Eb*Eb) * (x(0)*x(0) - Emin*Emin)) - r*norm);
}

int simulator::isInside(int nvert, vector<double> vertx, vector<double> verty, double testx, double testy){
  /* This function takes a test point (testx, testy) and checks if it is within an nvert-sided polygon defined by the vertices vertx and verty. Function is a slightly modified version of the one posted on https://wrf.ecse.rpi.edu//Research/Short_Notes/pnpoly.html */
  int i, j, c = 0;
  for (i = 0, j = nvert-1; i < nvert; j = i++){
    if ( ((verty[i]>testy) != (verty[j]>testy)) && (testx < (vertx[j]-vertx[i]) * (testy-verty[i]) / (verty[j]-verty[i]) + vertx[i]) )
       c = !c;
  }
  return c;
}

int simulator::select_member(vector<double> numbers, vector<double> weights){
  /* This function selects a member from a weighted ("weights") list of doubles ("numbers") */

  /* Calculate cumulative sum of weights to represent the probability that a number will be picked */
  vector<double> weights_cumsum; weights_cumsum.resize(weights.size());
  partial_sum(weights.begin(), weights.end(), weights_cumsum.begin());
  uniform_real_distribution<double> distribution(0.0, weights_cumsum.back());

  /* Generate random number, used to draw from numbers */
  double r = distribution(generator);

  /* Binary search to find which number to pick based on weight */
  int low = 0, high = numbers.size() - 1;
  while (high >= low){
      int guess = (low + high)/2;
      if (weights_cumsum[guess] < r){
          low = guess + 1;
        }
      else if (weights_cumsum[guess] - weights[guess] > r){
          high = guess - 1;
        }
      else {
          return guess;  // return the index for selected member in "numbers" array
        }
  }
  return -1; // if this is returned, somehting has gone wrong
}

vector<double> simulator::linspace(double min, double max, int N){
  vector<double> range; range.resize(N);
  /* Determine step-size */
  double delta = (max-min)/(N-1);

  /* Iterate over range, excluding the last entry */
  for (int i = 0; i < N-1; i++){
    range[i] = min + i * delta;
  }

  /* Set last entry to "max". This ensures that we get a range from min -> max */
  range.back() = max;
  return range;
}

void simulator::linterp(vector<double> x, vector<double> y, vector<double> xi, vector<double> &yi){
  yi.resize(xi.size());
  double dx = x[1] - x[0];  // x is monotonically increasing, so we can define dx outside loop. Otherwise calculate as dx = x[low+1] - x[low]
  for (size_t j = 0; j < xi.size(); j++){

    /* Find the interval over which to interpolate with binary search */
    int low = 0;
    int high = x.size() - 1;
    while (high - low > 1){
      int guess = (high + low)/2;
      if (xi[j] > x[guess]){
        low = guess;
      }
      else {
        high = guess;
      }
    }

    /* Calculate slope and do interpolation */
    double dydx = (y[low + 1] - y[low])/dx;
    yi[j] = y[low] + dydx * (xi[j] - x[low]);
  }
}

double simulator::VoseAliasMethod_draw(vector<int> Alias, vector<double> Prob){
  /* Make fair roll of n-sided die */
  int n = Prob.size(); uniform_int_distribution<int> distribution(0, n);
  int i = distribution(generator);

  /* Draw double from uniform dist. on [0, 1] */
  double r = R(generator);

  /* Determine output based comparison between biasesd and fair coin-toss */
  return r < Prob[i] ? i : Alias[i];
}

void simulator::VoseAliasMethod_table(vector<double> distro_in, vector<int> &Alias, vector<double> &Prob){
  /* Allocate space for Alias and Prob arrays */
  vector<double> distro = distro_in;
  int n = distro.size();
  Alias.resize(n); Prob.resize(n);

  /* average probability, used for comparison with distro. value */
  double average = 1.0 / n;

  /* Fill "Small" and "Large" array using distro. */
  vector<double> Small, Large;  // used to fill Alias and Prob
  for (int i = 0; i < n; i++){
      if (distro[i] < average){
        Small.push_back(i);
      }
      else {
        Large.push_back(i);
      }
    }

  /* Large may be emptied first due to innacuracy of doubles so use both criteria here. Mathematically Small should always be emptied first. */
  while (!Small.empty() and !Large.empty()){

    /* Obtain index of small (l) and large (g) prob, used to populate Alias and Prob arrays */
    double l = Small.back(); Small.pop_back();
    double g = Large.back(); Large.pop_back();

    /* Populate the Prob and Alias arrays */
    Prob[l] = distro[l] * n;
    Alias[l] = g;
    distro[g] += distro[l] - average;

    /* Populate Large and Small array */
    if (distro[g] < average){
      Small.push_back(g);
    }
    else {
      Large.push_back(g);
    }
  } // end while

  /* Now empty both lists setting probabilities to 1.0. Ensures numerical stability */
  while (!Large.empty()){
    double g = Large.back(); Large.pop_back();
    Prob[g] = 1.0;
  }
  while (!Small.empty()){
    double l = Small.back(); Small.pop_back();
    Prob[l] = 1.0;
  }
}

vec simulator::simplex_reflect(vec highest, vec centroid){
  /* Reflect highest point against centroid */
  return 2.0 * centroid - highest;
}

vec simulator::simplex_expand(vec highest, vec centroid){
  /* Reflect highest point against centroid, then double distance to centroid */
  return 3.0 * centroid - 2.0 * highest;
}

vec simulator::simplex_contract(vec highest, vec centroid){
  /* Highest point halves its distance from centroid */
  return 0.5 * (centroid + highest);
}

void simulator::simplex_reduce(vector<vec> &simplex, int ilow){
  /* All points, except lowest, halves their distance to lowest point */
  for (size_t i = 0; i < simplex.size(); i++){
    if ((int)i != ilow){
      simplex[i] = 0.5 * (simplex[i] + simplex[ilow]);
    }
  }
}

double simulator::simplex_size(vector<vec> simplex){
  /* Calculate size of the simplex-polygon */
  double s = norm(simplex[0] - simplex.back(), 2);
  for (size_t i = 1; i < simplex.size(); i++){
    double d = norm(simplex[i] - simplex[i - 1], 2);
    if (s < d){s = d;};
  }
  return s;
}

void simulator::simplex_update(vector<vec> simplex, vec fs, vec &centroid, int &ihigh, int &ilow){
  /* Update ihigh, ilow and centroid.  */
  ihigh = 0; double fhigh = fs(0);
  ilow = 0; double flow = fs(0);
  for (size_t i = 1; i < simplex.size(); i++){
    if (fs(i) > fhigh){
      fhigh = fs(i); ihigh = i;
    }
    if (fs(i) < flow){
      flow = fs(i); ilow = i;
    }
  }
  vec s; s.resize(simplex[0].size());
  for (int i = 0; i < (int)simplex.size(); i++){
    if (i != ihigh){
      s += simplex[i];
    }
  }
  for (int i = 0; i < (int)s.size(); i++){
    centroid(i) = s(i) / (simplex.size() - 1);
  }
}

void simulator::simplex_initiate(vector<vec> simplex, function<double(vec)> F, vec &fs){
  /* Build arma-vec of function values at simplex vertexes. Called when size of simplex is reducecd as well as before optimization begins */
  for (size_t i = 0; i < simplex.size(); i++){
    fs(i) = F(simplex[i]);
  }
}

vec simulator::simplex_NM(function<double(vec)> F, vector<vec> simplex, double simplex_size_goal){
  /* Nelder-Mead simplex algorithm. Tested on Himmelblau's function and Rosenbrock function. In principle able to optimize n-dimensional problems. */
  vec fs; fs.resize(simplex.size());
  vec centroid = zeros<vec>(simplex.size() - 1);
  simplex_initiate(simplex, F, fs);
  int ilow, ihigh;
  while (simplex_size(simplex) > simplex_size_goal){
    simplex_update(simplex, fs, centroid, ihigh, ilow); // update simplex with new fs values, this updates centroid, ihigh, ilow.
    vec r = simplex_reflect(simplex[ihigh], centroid);  // reflection
    double fr = F(r);

    /* try expansion */
    if (fr < fs(ilow)){
      vec e = simplex_expand(simplex[ihigh], centroid);
      double fe = F(e);
      if (fe < fr){ // accept expansion
        simplex[ihigh] = e;
        fs(ihigh) = fe;
      }
      else { // reject expansion and accept reflection
        simplex[ihigh] = r;
        fs(ihigh) = fr;
      }
    }
    else {
       /*if reflection is too poor, reflect in other direction */
      if (fr < fs(ihigh)){ // accept reflection
        simplex[ihigh] = r;
        fs(ihigh) = fr;
      }
      else { // reject reflection, try contraction
        vec c = simplex_contract(simplex[ihigh], centroid);
        double fc = F(c);
        if (fc < fs(ihigh)){ // accept contraction
          simplex[ihigh] = c;
          fs(ihigh) = fc;
        }
        else { // reject contraction and reduce
          simplex_reduce(simplex, ilow);
          simplex_initiate(simplex, F, fs);
        }
      }
    }
  } // end while
  return simplex[ilow];
}
