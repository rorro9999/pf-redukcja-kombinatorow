CXX = g++
CXXFLAGS = -std=c++23 -g -fsanitize=address,undefined,float-divide-by-zero -Wall -Wextra -Og
#CXXFLAGS = -std=c++23 -Ofast

genTest.e: genTest.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
