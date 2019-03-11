#include "pre_processor.h"

PreProcessor::PreProcessor(string config_file)
{
    /* Define parameters for constructor */
    legal_input_ = {
        "BeamEnergy",
        "CrystalThickness",
        "BeamProfile",
        "cut_lb_x",
        "cut_ub_x",
        "cut_lb_y",
        "cut_ub_y",
        "OutputFilename",
        "CrystalType",
        "runno",
        "DataPath",
        "TheorySepctrum",
        "IncludeBG",
        "NEvents",
        "Simulation"};
    /* Assign default values to angular cuts */
    config_.cut_lb_x = config_.cut_lb_y = (-1.0) * 1E+17;
    config_.cut_ub_x = config_.cut_ub_y = 1E+17;
    /* Initialize simulation input parameters */
    cout << "\nConfig-struct contains:\n";
    try
    {
        InitializeInputVariables(config_file);
    }
    catch (const char *msg)
    {
        cerr << msg << endl;
    }
    z_ = {0, 1832.3E+03, 8913E+03, 8989E+03, 9196.2E+03, 9273.7E+03};
    cout << "Entry angles x : {" << config_.cut_lb_x << ", " << config_.cut_ub_x << "} rad\n";
    cout << "Entry angles y : {" << config_.cut_lb_y << ", " << config_.cut_ub_y << "} rad\n";
    cout << "z : {" << z_[0] << ", " << z_[1] << ", " << z_[2] << ", " << z_[3] << ", " << z_[4] << ", " << z_[5] << "}\n";
}

void PreProcessor::InitializeInputVariables(std::string filename)
{
    std::ifstream config_file(filename);
    std::string key;
    std::string value;
    bool EmptyFile = true;
    if (config_file.is_open())
    {
        while (true)
        {
            config_file >> key >> value;
            if (config_file.eof())
            {
                if (EmptyFile)
                {
                    throw "config file appears to be empty!\n";
                }
                break;
            }
            EmptyFile = false;
            InitializeInputVariablesHelper(key, value);
        }
    }
    else
    {
        throw "Unable to open config file!\n";
    }
}

void PreProcessor::InitializeInputVariablesHelper(std::string key, std::string value)
{
    int index = SearchList(legal_input_, key);
    switch (index)
    {
    case 0:
        config_.BeamEnergy = std::stod(value);
        std::cout << "BeamEnergy : " << config_.BeamEnergy << "\n";
        break;
    case 1:
        config_.CrystalThickness = std::stod(value);
        std::cout << "CrystalThickness : " << config_.CrystalThickness << "\n";
        break;
    case 2:
        config_.BeamProfile = value;
        std::cout << "BeamProfile : " << config_.BeamProfile << "\n";
        break;
    case 3:
        config_.cut_lb_x = std::stod(value);
        break;
    case 4:
        config_.cut_ub_x = std::stod(value);
        break;
    case 5:
        config_.cut_lb_y = std::stod(value);
        break;
    case 6:
        config_.cut_ub_y = std::stod(value);
        break;
    case 7:
        config_.OutputFilename = value;
        std::cout << "OutputFilename : " << config_.OutputFilename << "\n";
        break;
    case 8:
        config_.CrystalType = value;
        std::cout << "CrystalType : " << config_.CrystalType << "\n";
        break;
    case 9:
        config_.runno = value;
        std::cout << "runno : " << config_.runno << "\n";
        break;
    case 10:
        config_.DataPath = value;
        std::cout << "DataPath : " << config_.DataPath << "\n";
        break;
    case 11:
        config_.TheorySpectrum = value;
        std::cout << "TheorySpectrum : " << config_.TheorySpectrum << "\n";
        break;
    case 12:
        config_.IncludeBG = stoi(value);
        std::cout << "IncludeBG : " << config_.IncludeBG << "\n";
        break;
    case 13:
        config_.NEvents = stoi(value);
        std::cout << "NEvents : " << config_.NEvents << "\n";
        break;
    case 14:
        config_.Simulation = stoi(value);
        std::cout << "Simulation : " << config_.Simulation << "\n";
        break;
    case -1:
        std::cerr << "\nIllegal variable name:\t'" << key << "'\tin config file\n";
        std::cerr << "Legal variable names are:\n";
        for (std::string key : legal_input_)
        {
            std::cerr << key << "\n";
        }
        std::cerr << std::endl;
        break;
    }
}

int PreProcessor::SearchList(std::vector<std::string> list, std::string key)
{
    for (size_t i = 0; i < list.size(); i++)
    {
        if (key == list[i])
        {
            return i;
        }
    }
    return -1;
}