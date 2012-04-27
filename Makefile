CXXFLAGS = -std=gnu++0x -g -O0 -I$(LIBUV_PATH)/include -I$(HTTP_PARSER_PATH) -I. -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64

ifeq ($(OS),Windows_NT)
  EXTRALIB=-lws2_32 -lpsapi -liphlpapi
else
  OS_NAME=$(shell uname -s)
  ifeq (${OS_NAME},Darwin)
	EXTRALIB=
  else
	EXTRALIB=-lrt
  endif
endif

all: webclient webserver file_test

webclient: webclient.cpp $(LIBUV_PATH)/uv.a $(HTTP_PARSER_PATH)/http_parser.o $(wildcard native/*.h)
	$(CXX) $(CXXFLAGS) -o webclient webclient.cpp $(LIBUV_PATH)/uv.a $(HTTP_PARSER_PATH)/http_parser.o $(EXTRALIB) -lm -lpthread
	
webserver: webserver.cpp $(LIBUV_PATH)/uv.a $(HTTP_PARSER_PATH)/http_parser.o $(wildcard native/*.h)
	$(CXX) $(CXXFLAGS) -o webserver webserver.cpp $(LIBUV_PATH)/uv.a $(HTTP_PARSER_PATH)/http_parser.o $(EXTRALIB) -lm -lpthread
	
file_test: file_test.cpp $(LIBUV_PATH)/uv.a $(HTTP_PARSER_PATH)/http_parser.o $(wildcard native/*.h)
	$(CXX) $(CXXFLAGS) -o file_test file_test.cpp $(LIBUV_PATH)/uv.a $(HTTP_PARSER_PATH)/http_parser.o $(EXTRALIB) -lm -lpthread

$(LIBUV_PATH)/uv.a:
	$(MAKE) -C $(LIBUV_PATH)

$(HTTP_PARSER_PATH)/http_parser.o:
	$(MAKE) -C $(HTTP_PARSER_PATH) http_parser.o
	
clean:
	rm -f $(LIBUV_PATH)/uv.a
	rm -f $(HTTP_PARSER_PATH)/http_parser.o
	rm -f webclient webserver file_test
