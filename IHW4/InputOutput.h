
#ifndef GARDEN_INPUTOUTPUT_H
#define GARDEN_INPUTOUTPUT_H
std::string inputFile;
std::string outputFile = "output.txt"; // по умолчанию такой.
pthread_mutex_t consoleMutex = PTHREAD_MUTEX_INITIALIZER; // Мьютекс для вывода, чтобы на консоли и в файле сообщения не перебивали друг друга.

void printMessage(const std::string &message) { // Печать данных на экран и в файл.
    pthread_mutex_lock(&consoleMutex);
    std::cout << message << std::endl;
    std::ofstream output(outputFile, std::ios::app);
    if (!output.is_open()) {
        std::cerr << "Error while opening file!\n";
    } else {
        output << message << "\n";
        output.close();
    }
    pthread_mutex_unlock(&consoleMutex);
}

int InputCMD(int argc, char *argv[]) {
    int maxWatering = 40;
    if (argc >= 4 && std::string(argv[1]) == "-o") {
        // Ввод с командной строки: -o output3.txt -m 50
        outputFile = argv[2];
        if (std::string(argv[3]) == "-m" && argc >= 5) {
            maxWatering = std::stoi(argv[4]);
        } else {
            std::cerr << "Using default parameters .\n";
        }
    } else if (argc >= 3 && std::string(argv[1]) == "-i") {
        // ввод с файла:  -i input.txt
        inputFile = argv[2];
        std::ifstream file(inputFile);
        if (!file.is_open()) {
            std::cerr << "Incorrect Input! Using default parameters .\n";
        } else {
            // Чтение параметров из файла
            if (getline(file, outputFile) && file >> maxWatering) {
                file.close();
            } else {
                std::cerr << "Incorrect Input! Using default parameters .\n";
            }
        }
    } else {
        std::cerr << "Incorrect Input! Using default parameters .\n";
    }
    return maxWatering;
}

#endif //GARDEN_INPUTOUTPUT_H
