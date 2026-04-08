#include <bits/stdc++.h>

#define INCORRECT_ARGS_FOR_MAIN (ugly >= 8 ? combinatorList : vector<string>{})
#define RANDOM_WHITESPACE string(((rng() % 2 == 1) && (ugly >= 4)) ? " " : "")
#define EXPECTED_ARGS (14+1)

using namespace std;

mt19937 rng;
uniform_int_distribution uniKombArg, uniKombWyn, uniKombinator; //uniformKombinatorArgument, uniformKombinatorWynik
uniform_real_distribution uniR; //[0, 1]
int biasArg, biasWyn; //bias, jak w testlib
string Const = "A";
double probComb, probOpen, probClose, probArgs, probIncorrect; //probability of a combinator in main, probability of '(' and ')' in comb/main, percentage of args/(args+combinators) in combinator definitions, probability of an incorrect definition of a combinator
int ugly;

template<typename T>
vector<T> operator+(const vector<T> &lhs, const vector<T> &rhs) {
    vector<T> res = lhs;
    res.insert(res.end(), rhs.begin(), rhs.end());
    return res;
}

vector<string> combinatorList, combinatorDefinitionList;
string nextString(string s) {
    int lower = s[0] & 0x20;
    for (char &c : s)
        c -= lower;
        //c = c & ((-1) + 0x20);
    int i = s.length();
    while (i > 0) {
        if (s[i-1] == 'Z') {
            s[i-1] = 'A';
            --i;
        } else {
            ++s[i-1];
            for (char &c : s)
                c += lower;
            return s;
        }
    }
    s += 'A';
    for (char &c : s)
        c += lower;
    return s;
}

double getRandomDouble(uniform_real_distribution<> &dist, int bias) {
    if (bias < 0)
        return min(dist(rng), getRandomDouble(dist, bias+1));
    if (bias > 0)
        return max(dist(rng), getRandomDouble(dist, bias-1));
    return dist(rng);
}

int getRandomInt(uniform_int_distribution<> &dist, int bias) {
    if (bias < 0)
        return min(dist(rng), getRandomInt(dist, bias+1));
    if (bias > 0)
        return max(dist(rng), getRandomInt(dist, bias-1));
    return dist(rng);
}

string randomFromVec(vector<string> &v) {
    return v[rng() % v.size()];
}

vector<string> combinate(vector<string> &v, int mx, string comb) {

    vector<pair<int, int>> counter; //per floor <deeper parentheses, tokens> . won't allow the closure of utterly useless parentheses
    counter.push_back(make_pair(0, 0));
    vector<string> tokens;
    int cnt = 0;
    size_t depth = 0;
    do {
        double roll = getRandomDouble(uniR, 0);
        double cum = 0; //cumulative probability of events
        if (roll < probOpen) { //(
            if (depth >= (mx-cnt-1))
                continue;
            tokens.emplace_back("(");
            ++counter.back().first;
            ++depth;
            counter.push_back(make_pair(0, 0));
            continue;
        }
        roll = getRandomDouble(uniR, 0);
        if (roll < probClose + cum && depth > 0 && !(!counter.back().second && counter.back().first <= 1)) { //)
            tokens.emplace_back(")");
            counter.pop_back();
            --depth;
            continue;
        }
        cum += probClose;
        ++counter.back().second;
        if (roll < probIncorrect + cum) { //constant
            tokens.emplace_back(Const);
            Const = nextString(Const);
            ++cnt;
            continue;
        }
        roll = getRandomDouble(uniR, 0);
        if (roll < probArgs) { //argument
            if (v.size() <= 0)
                continue;
            tokens.emplace_back(randomFromVec(v));
        } else { //combinator
            string combi;
            do { combi = combinatorList[getRandomInt(uniKombinator, 0)]; } while (combi == comb); //cant self refer
            tokens.emplace_back(combi);
        }
        ++cnt;
    } while (cnt < mx);
    while (depth > 0) {
        tokens.push_back(")");
        --depth;
    }
    return tokens;
}

string tokensToString(const vector<string> &v) {
    string res = v[0];
    for (int i = 1; i < (int)v.size(); ++i) {
        bool addSpace = true;
        if (")" == v[i] || "(" == v[i-1])
            addSpace = false;
        if (addSpace)
            res += " " + RANDOM_WHITESPACE + RANDOM_WHITESPACE;
        res += v[i];
    }
    return res;
}

string defineCombinator(string comb) {
    vector<string> tokens;
    tokens.push_back(comb);
    //get arguments
    int argc = getRandomInt(uniKombArg, biasArg);
    vector<string> argList;
    string a = nextString(combinatorList.back());
    if (argc)
        argList.push_back(a);
    a = nextString(a);
    for (int i = 1; i < argc; ++i) {
        if (getRandomDouble(uniR, 0) > probIncorrect) {
            argList.push_back(a);
            a = nextString(a);
        } else {
            if (getRandomDouble(uniR, 0) < 0.5) {
                argList.push_back(randomFromVec(argList)); //not ideal, but works
            } else {
                argList.push_back(combinatorList[getRandomInt(uniKombinator, 0)]);
            }
        }
    }
    shuffle(argList.begin(), argList.end(), rng);
    vector<string> combinatedStuff = combinate(argList, getRandomInt(uniKombWyn, biasWyn), comb);
    return tokensToString(vector<string>{comb} + argList + vector<string>{"="} + combinatedStuff);
}

string makeMain(int len) {
    vector<string> tokens{"main", "="};
    //probability of a combinator has to be actually set, so we will change probability of incorrect, since it's fine here
    //we have p = 1 - #( - #)
    //of the left probability, we want:
    //probIncorrect = 1 - probComb
    //(1-p)*probComb, probIncorrect (1-p)*(1-probComb)
    probIncorrect = (1 - probComb) * (1 - probOpen - probClose);
    return tokensToString(vector<string>{"main"} + INCORRECT_ARGS_FOR_MAIN + vector<string>{"="} + combinate(combinatorList, len, "main"));
}

int main(int argc, char *argv[]) {
    if (argc != EXPECTED_ARGS) {
        cerr << "przeczytaj readme.md, oczekuje " << EXPECTED_ARGS - 1 << " arguemntow, otrzymalem " << argc - 1 << " argumentow " << '\n';
        return -1;
    }
    rng = mt19937(atoi(argv[1]));
    uniKombArg = uniform_int_distribution<>(0, atoi(argv[4]));
    uniKombWyn = uniform_int_distribution<>(0, atoi(argv[6]));
    uniKombinator = uniform_int_distribution<>(0, atoi(argv[2])-1);
    biasArg = atoi(argv[5]);
    biasWyn = atoi(argv[7]);
    probArgs = atof(argv[13]);
    probIncorrect = atof(argv[12]);
    ugly = atoi(argv[14]);

    combinatorList = {"a"};
    for (int i = 1; i < atoi(argv[2]); ++i) {
        combinatorList.push_back(nextString(combinatorList.back()));
        if (combinatorList.back() == "main") {
            cerr << "nie wiem co robisz, ale masz za duzo kombinatorow\n";
            return -1;
        }
    }

    probComb = atof(argv[3]);
    probOpen = atof(argv[8]);
    probClose = atof(argv[9]);

    for (int i = 0; i < atoi(argv[2]); ++i) {
        combinatorDefinitionList.push_back(defineCombinator(combinatorList[i]));
    }

    int impostor = atoi(argv[11]);
    for (int i = 0; i < impostor; ++i) {
        combinatorDefinitionList.push_back(defineCombinator(combinatorList[getRandomInt(uniKombinator, 0)]));
    }

    combinatorDefinitionList.push_back(makeMain(atoi(argv[10])));

    if (ugly >= 1)
        shuffle(combinatorDefinitionList.begin(), combinatorDefinitionList.end(), rng);

    for (string s : combinatorDefinitionList)
        cout << s << '\n';

    return 0;
}
