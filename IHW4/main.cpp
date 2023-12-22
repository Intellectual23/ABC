#include <iostream>
#include <fstream>
#include <pthread.h>
#include <unistd.h>
#include <ctime>
#include <random>
#include <algorithm>
#include "InputOutput.h"

const int MAX_FLOWERS = 40; // По условию 40 цветков.
int MAX_WATERING = 40;
int wateringCount = 0;      // Счётчик политых цветов.

pthread_mutex_t wateringMutex = PTHREAD_MUTEX_INITIALIZER; // Мьютекс для поливкки, чтобы два садовника не поливали одновременно один и тот же цветок.

int Generate(const int maxValue) { // Генерация данных от 0 до заданной границы.
    static std::mt19937 eng(std::time(NULL));
    std::uniform_int_distribution<int> distribution(0, maxValue);
    return distribution(eng);
}

enum FlowerState { // Три состояния цветка.
    Watered, NeedsWatering, DriedOrRoten
};

class Flower { // Класс цветка
public:
    int _flowerNum{};
    FlowerState _flowerState;

    Flower() = default; // Конструктор по умолчанию.

    explicit Flower(int num) : _flowerNum(num), _flowerState(FlowerState::NeedsWatering) {}

    void Water(std::string gardenerName) { // Cмена состояния цветка при поливке.
        if (_flowerState != FlowerState::DriedOrRoten) {
            printMessage("= " + gardenerName + " is watering Flower #" + std::to_string(_flowerNum) + "");
            if (_flowerState == NeedsWatering) {
                _flowerState = Watered;
            } else {
                _flowerState = DriedOrRoten; // (Roten)
            }
            return;
        }
        printMessage("+ Flower #" + std::to_string(_flowerNum) + " is already dead. It doesn't need any water, " +
                     gardenerName + "");
    }

    void Dry() { // Сушит живой цветок.
        if (_flowerState == Watered) {
            _flowerState = NeedsWatering;
        } else if (_flowerState == NeedsWatering) {
            _flowerState = DriedOrRoten; // (Dried)
        }
    }
};

Flower *flowers[MAX_FLOWERS]; // Массив цветов, глобальный, чтобы у садовников и клумбы был к ним доступ

void initFlowers() { //инициализация цветов от 1 до 40
    for (int i = 0; i < MAX_FLOWERS; ++i) {
        flowers[i] = new Flower(i + 1);
    }
}

class Gardener { // класс садовника
public:
    std::string _name;
    pthread_t thread{}; // его поток.

    Gardener(std::string gardenerName) : _name(std::move(gardenerName)) {
        pthread_create(&thread, NULL, &Gardener::WrappedWatering, this); // инициализация потока
    }

    static void *WrappedWatering(void *gardener) {
        static_cast<Gardener *>(gardener)->Water();
        return NULL;
    }

    void Water() {
        while (wateringCount < MAX_WATERING) { // условие конца работы потоков
            pthread_mutex_lock(&wateringMutex);
            auto curFlower = ChooseFlower();
            curFlower->Water(_name); // выбираем цветок для поливки
            pthread_mutex_unlock(&wateringMutex);
            usleep(Generate(
                    2000000)); // Используем генератор чисел - задержки садовника перед следующим поливом - до 2-х секунд.
            ++wateringCount; // увеличиваем счетчик поливов
        }
        pthread_exit(NULL);
    }

    ~Gardener() {
        pthread_join(thread, NULL); // Запуск потока.
    }


private:
    Flower *ChooseFlower() {
        // Создаем другой генератор случайных чисел
        std::random_device rd;
        std::mt19937 g(rd());
        std::shuffle(std::begin(flowers), std::end(flowers),
                     g); //Для красоты и чтобы поливались случайные нуждающиеся цветы, перемешиваем массив цветов.
        for (auto &flower: flowers) {
            if (flower->_flowerState ==
                NeedsWatering) { // и берем первый нуждающийся цветок из перемешанного массива.
                return flower;
            }
        }
        return flowers[Generate(MAX_FLOWERS -
                                1)]; // Если все мертвы или политы (что маловероятно), берем рандомный. Используем тот же генератор чисел.
    }
};

class Garden { // Класс клумбы.
public:
    pthread_t thread{}; // ее поток

    Garden() {
        pthread_create(&thread, NULL, &Garden::MonitorFlowers, this);// Инициализация потока
    }

    static void *MonitorFlowers(void *arg) { // Вывод информации о каждом цветке + запуск засухи
        Garden *garden = (Garden *) arg;
        usleep(100000);
        while (wateringCount < MAX_WATERING) {
            for (int i = 0; i < MAX_FLOWERS; ++i) {
                Flower *flower = flowers[i];
                if (flower->_flowerState == NeedsWatering) {
                    printMessage("- Flower #" + std::to_string(flower->_flowerNum) + " needs watering!");
                } else if (flower->_flowerState == DriedOrRoten) {
                    printMessage("- Flower #" + std::to_string(flower->_flowerNum) + " is dried or roten :(");
                } else {
                    printMessage("- Flower #" + std::to_string(flower->_flowerNum) + " is watered :)");
                }
            }
            usleep(10000000); // Ждём 10 секунд перед следующей засухой
            for (int i = 0; i < MAX_FLOWERS; ++i) { // Засуха!
                flowers[i]->Dry(); // Вызов метода Dry() для всех цветов
            }
        }
        return NULL;
    }

    ~Garden() {
        pthread_join(thread, NULL);// Запуск потока
    }
};

int main(int argc, char *argv[]) {
    // Установка кодировки консоли
    MAX_WATERING = InputCMD(argc, argv);// по умолчанию 40 поливок, и выходной файл output.txt
    initFlowers();// Заполняем массив цветов цветами.
    Garden garden; // Создали Клумбу, в ней создан поток с мониторингом.
    Gardener mario = Gardener("Mario"); // Создаем двух садовников с потоками-поливками.
    Gardener luigi = Gardener("Luigi");

    return 0;
}
