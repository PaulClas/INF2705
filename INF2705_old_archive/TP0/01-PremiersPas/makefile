CXXFLAGS += -g -W -Wall -Wno-unused-parameter -Wno-deprecated-declarations -Wvla -Wno-c++11-extensions # -pedantic -std=c++11
CXXFLAGS += -I/usr/X11/include -I/opt/local/include

LDFLAGS += -L/usr/X11/lib -L/opt/local/lib
LDFLAGS += -lglut -lGLU -lGL

SRC=main

exe : $(SRC).exe
run : exe
	./$(SRC).exe
$(SRC).exe : *.cpp *.h
	$(CXX) $(CXXFLAGS) -o$@ $(SRC).cpp Etat.cpp $(LDFLAGS)

clean :
	rm -rf *.o *.exe *.exe.dSYM
