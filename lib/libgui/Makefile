##########################################################
# Copyright 2016-2080 evilbinary.
#作者:evilbinary on 12/24/16.
#邮箱:rootdebug@163.com
##########################################################


TARGET = libgui.so 
OBJS =  edit.o graphic.o shader.o mat4.o fontstash.o stb_truetype.o utf8-utils.o
PLATFORM=
BITS =$(shell getconf LONG_BIT)


LIBS = -L../libgl -lgles
CFLAGS = -Wall -Wformat -g  -DGLAD \
	-I../libgl \

CXXFLAGS= -Wall -Wformat

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S), Linux) #LINUX
	ECHO_MESSAGE = "Linux"
	LIBS += 
	CXXFLAGS += 
	CXXFLAGS += 
	CFLAGS +=  -fPIC -std=c99
	ifeq ($(BITS), 32)
		PLATFORM=i3le
	else
		PLATFORM=a6le
	endif
endif

ifeq ($(UNAME_S), Darwin) #APPLE
	ECHO_MESSAGE = "Mac OS X"
	LIBS +=  -L/opt/local/lib/ 
	CXXFLAGS += 
	CXXFLAGS += 
	CFLAGS +=  -I/opt/local/include/ 
	ifeq ($(BITS), 32)
		PLATFORM=i3osx
	else
		PLATFORM=a6osx
	endif
#	CXXFLAGS += -D__APPLE__
endif

ifeq  ($(findstring MINGW32_NT-, $(UNAME_S)), MINGW32_NT-)
   	ECHO_MESSAGE = "Windows"
	LIBS += 
	CXXFLAGS += 
	CXXFLAGS += 
	CFLAGS +=
	PLATFORM=i3nt
	TARGET = libgui.dll
endif

ifeq  ($(findstring MINGW64_NT-, $(UNAME_S)), MINGW64_NT-)
   	ECHO_MESSAGE = "Windows64"
	LIBS += 
	CXXFLAGS += 
	CXXFLAGS += 
	CFLAGS +=   -DGLAD  -DGLAD_GLAPI_EXPORT  -DGLAD_GLAPI_EXPORT_BUILD 
	PLATFORM=ta6nt
	TARGET = libgui.dll
endif


.cpp.o:
	$(CXX) $(CXXFLAGS) -c -o $@ $<
.c.o:
	$(CC) $(CFLAGS) -c -o $@ $<
all: $(TARGET)
	@echo Build complete for $(ECHO_MESSAGE)

$(TARGET): $(OBJS)
	$(CC)  $(CFLAGS) $(OBJS) -shared  -o $(TARGET)   $(LIBS)

boot:
	cp ../libchez/$(PLATFORM)/*.boot .
clean:
	rm -rf $(TARGET) $(OBJS)

