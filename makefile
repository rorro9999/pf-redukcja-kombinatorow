CXX = g++
CXXFLAGS = -std=c++23 -g -fsanitize=address,undefined,float-divide-by-zero -Wall -Wextra -Og
CXXFLAGS = -std=c++23 -O3

genTest.e: genTest.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

test.e: test.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

clean:
	rm -f test.e genTest.e
