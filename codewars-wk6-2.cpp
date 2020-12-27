#include <chrono>
#include <iostream>
#include <numeric>
#include <sstream>
#include <string>
#include <utility>

using namespace std;
using namespace std::chrono;
using biguint = unsigned long long int;

pair<biguint, biguint> add_fractions(biguint num1, biguint denom1, biguint num2, biguint denom2) {
    biguint lmult = lcm(denom1, denom2);
    biguint new_denom = lmult;
    biguint new_num = num1 * (lmult/denom1);
    new_num += (num2 * (lmult/denom2));

    return make_pair(new_num, new_denom);
}

class Suite2 {
public:
    static string game(biguint n);
};

string Suite2::game(biguint n) {
    biguint numerator = 0;
    biguint denominator = 1;
    biguint divisor = 1;
    ostringstream res;

    for (biguint row_denom = 1; row_denom < n + 1; ++row_denom) {
        for (biguint col_num = 1; col_num < n + 1; ++col_num) {
            tie(numerator, denominator) = add_fractions(numerator, denominator,
                                                        col_num, row_denom + col_num);

            divisor = gcd(numerator, denominator);
            if (divisor > 1) {
                numerator /= divisor;
                denominator /= divisor;
            }
        }
    }
    
    if (numerator == 0 || denominator == 1) {
        res << "[" << numerator << "]";
        return res.str();
    } else {
        res << "[" << numerator << ", " << denominator << "]";
        return res.str();
    }
}

int main() {
    if (Suite2::game(0) != "[0]") {
        cout << "game(0) result wrong\n";
        return 1;
    }
    if (Suite2::game(1) != "[1, 2]") {
        cout << "game(1) result wrong\n";
    }
    if (Suite2::game(8) != "[32]") {
        cout << "game(8) result wrong\n";
    }

    auto start = high_resolution_clock::now();
    Suite2::game(512);
    auto stop = high_resolution_clock::now();
    auto duration = duration_cast<microseconds>(stop - start);

    cout << "game(512) took " << duration.count()/1'000'000.0 << " seconds\n";

    return 0;
}
