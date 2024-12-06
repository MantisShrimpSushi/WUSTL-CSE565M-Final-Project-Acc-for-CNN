#include "cnn.h"
#include "utils.h"
#include <cstdio>
#include <ctime>
#include <iostream>
#include <fstream>

#define N 10

int
read_images(const char* file, float images[N][IMG_ROWS][IMG_COLS]) {
    FILE* fp = fopen(file, "r");
    if (fp == NULL)
        return -1;

    for (int i = 0; i < N; ++i)
        for (int x = 0; x < IMG_ROWS; ++x)
            for (int y = 0; y < IMG_COLS; ++y)
                (void)fscanf(fp, "%f", &images[i][x][y]);

    return fclose(fp);
}

int
read_labels(const char* file, int labels[N]) {
    FILE* fp = fopen(file, "r");
    if (fp == NULL)
        return -1;

    for (int i = 0; i < N; ++i)
        (void)fscanf(fp, "%d", &labels[i]);

    return fclose(fp);
}

int
get_max_prediction(float prediction[DIGITS]) {
    int max_digit = 0;
    for (int i = 0; i < DIGITS; ++i) {
        if (prediction[i] > prediction[max_digit])
            max_digit = i;
    }
    return max_digit;
}

int main() {
    const char* imagesFile = "../02-Data/in.dat";
    const char* labelsFile = "../02-Data/out.dat";

    float images[N][IMG_ROWS][IMG_COLS];
    if (0 != read_images(imagesFile, images)) {
        std::cerr << "Error: can't open file ``" << imagesFile << "''" << std::endl;
        return EXIT_FAILURE;
    }

    int labels[N];
    if (0 != read_labels(labelsFile, labels)) {
        std::cerr << "Error: can't open file ``" << labelsFile << "''" << std::endl;
        return EXIT_FAILURE;
    }

    double time = 0;
    int correct_predictions = 0;
    float prediction[DIGITS];

    for (int i = 0; i < N; ++i) {
        clock_t begin = clock();
        cnn(images[i], prediction);
        clock_t end = clock();

        std::cout << "Image " << i + 1 << " prediction:\n";
        for (int j = 0; j < DIGITS; ++j) {
            std::cout << "Digit " << j << ": " << prediction[j] << "\n";
        }

        if (get_max_prediction(prediction) == labels[i]) {
            ++correct_predictions;
        }
        else {
            std::cout << "\nExpected: " << labels[i] << "\n";
            float pad_img[PAD_IMG_ROWS][PAD_IMG_COLS];
            normalization_and_padding(images[i], pad_img);
            print_pad_img(pad_img);
            std::cout << "Prediction:\n";
            for (int j = 0; j < DIGITS; ++j)
                std::cout << j << ": " << prediction[j] << "\n";
            std::cout << "\n";
        }

        double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
        time += time_spent;
    }

    double correct_predictions_perc = correct_predictions * 100.0 / (double)N;
    std::cout << "\n";
    std::cout << "Total predictions: " << N << "\n";
    std::cout << "Correct predictions: " << correct_predictions_perc << " %\n";
    std::cout << "Average latency: " << (time / N) * 1000 << " (ms)\n";
    std::cout << "\n";

    return EXIT_SUCCESS;
}
