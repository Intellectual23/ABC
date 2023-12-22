#include <iostream>
#include <pthread.h>
#include <unistd.h>
#include <ctime>
#include <random>
#include <algorithm>

const int MAX_FLOWERS = 40;
const int MAX_WATERING = 40;
int wateringCount = 0;
pthread_mutex_t consoleMutex = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t wateringMutex = PTHREAD_MUTEX_INITIALIZER;

void printMessage(const std::string &message) {
    pthread_mutex_lock(&consoleMutex);
    std::cout << message << std::endl;
    pthread_mutex_unlock(&consoleMutex);
}

int Generate(const int maxValue) {
    static std::mt19937 eng(std::time(NULL));
    std::uniform_int_distribution<int> distribution(0, maxValue);
    return distribution(eng);
}

enum FlowerState {
    Watered, NeedsWatering, DriedOrRoten
};

class Flower {
public:
    int _flowerNum;
    std::string _wateringBy;
    pthread_mutex_t flowerMutex{};
    FlowerState _flowerState;
    bool _isWatering;

    Flower() = default;

    Flower(int num) : _flowerNum(num), _flowerState(FlowerState::NeedsWatering), _isWatering(false) {
        pthread_mutex_init(&flowerMutex, NULL);
    }

    void Water(std::string gardenerName) {
        pthread_mutex_lock(&flowerMutex);
        if (_flowerState != FlowerState::DriedOrRoten) {
            _isWatering = true;
            printMessage(gardenerName + " is watering Flower #" + std::to_string(_flowerNum) + "");
            if (_flowerState == NeedsWatering) {
                _flowerState = Watered;
            } else {
                _flowerState = DriedOrRoten; // (Roten)
            }
            _isWatering = false;
            pthread_mutex_unlock(&flowerMutex);
            return;
        }
        printMessage("Flower #" + std::to_string(_flowerNum) + " is already dead. It doesn't need any water, " +
                     gardenerName + "");
        pthread_mutex_unlock(&flowerMutex);
    }

    void Dry() {
        if (_flowerState == Watered) {
            _flowerState = NeedsWatering;
        } else if (_flowerState == NeedsWatering) {
            _flowerState = DriedOrRoten; // (Dried)
        }
    }

private:

};

Flower *flowers[MAX_FLOWERS];

void initFlowers() {
    for (int i = 0; i < MAX_FLOWERS; ++i) {
        flowers[i] = new Flower(i + 1);
    }
}

class Gardener {
public:
    std::string _name;
    pthread_t thread{};
    Flower *_flower;

    Gardener(std::string gardenerName) : _name(std::move(gardenerName)) {
        pthread_create(&thread, NULL, &Gardener::WrappedWatering, this);
    }

    ~Gardener() {
        pthread_join(thread, NULL);
    }

    static void *WrappedWatering(void *gardener) {
        static_cast<Gardener *>(gardener)->Water();
        return NULL;
    }

    void Water() {
        while (wateringCount < MAX_WATERING) {
            pthread_mutex_lock(&wateringMutex);
            auto curFlower = ChooseFlower();
            curFlower->Water(_name);
            pthread_mutex_unlock(&wateringMutex);
            usleep(2000000);
            ++wateringCount;
        }
        pthread_exit(NULL);
    }

private:
    Flower *ChooseFlower() {
        // Создаем генератор случайных чисел
        std::random_device rd;
        std::mt19937 g(rd());
        std::shuffle(std::begin(flowers), std::end(flowers), g);
        for (int i = 0; i < MAX_FLOWERS; ++i) {
            if (flowers[i]->_flowerState == NeedsWatering && !flowers[i]->_isWatering) {
                return flowers[i];
            }
        }
        return flowers[Generate(MAX_FLOWERS - 1)]; // random
    }
};

class Garden {
public:
    pthread_t thread{};
    pthread_mutex_t gardenMutex = PTHREAD_MUTEX_INITIALIZER;
    pthread_cond_t gardenCond = PTHREAD_COND_INITIALIZER;

    static void *MonitorFlowers(void *arg) {
        Garden *garden = (Garden *) arg;
        usleep(100000);
        while (wateringCount < MAX_WATERING) {
            pthread_mutex_lock(&garden->gardenMutex);
            for (int i = 0; i < MAX_FLOWERS; ++i) {
                Flower *flower = flowers[i];
                pthread_mutex_lock(&flower->flowerMutex);
                if (flower->_flowerState == NeedsWatering) {
                    printMessage("-Flower #" + std::to_string(flower->_flowerNum) + " needs watering!");
                } else if (flower->_flowerState == DriedOrRoten) {
                    printMessage("-Flower #" + std::to_string(flower->_flowerNum) + " is dried or roten :(");
                } else {
                    printMessage("-Flower #" + std::to_string(flower->_flowerNum) + " is watered :)");
                }
                pthread_mutex_unlock(&flower->flowerMutex);
            }
            usleep(10000000);
            for (int i = 0; i < MAX_FLOWERS; ++i) {
                pthread_mutex_lock(&flowers[i]->flowerMutex);
                flowers[i]->Dry(); // Вызов метода Dry() для всех цветов
                pthread_mutex_unlock(&flowers[i]->flowerMutex);
            }
            pthread_cond_broadcast(&garden->gardenCond);
            pthread_mutex_unlock(&garden->gardenMutex);
        }
        return NULL;
    }

    Garden() {
        pthread_create(&thread, NULL, &Garden::MonitorFlowers, this);
    }

    ~Garden() {
        pthread_join(thread, NULL);
    }
};

int main() {
    initFlowers();
    Garden garden;
    Gardener mario = Gardener("Mario");
    Gardener luigi = Gardener("Luigi");
    return 0;
}
