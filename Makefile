#MACROS
# $(1): Compiler
# $(2): Object file to generate
# $(3): Source file
# $(4): Additional dependencies
# $(5): Compiler flags
define COMPILE
$(2) : $(3) $(4)
	$(1) $(5) -c -o $(2) $(3) $(6)
endef

# $(1): Source file
define C2O
$(patsubst %.c,%.o,$(patsubst %.cpp,%.o,$(patsubst $(SRC)%,$(OBJ)%,$(1))))
endef

define C2H
$(patsubst %.c,%.h,$(patsubst %.cpp,%.hpp,$(patsubst $(SRC)%,$(INCL)%,$(1))))
endef

#CONFIG
APP 		:= libpicopng.a
CCFLAGS 	:= -Wall -pedantic -std=c++17
CFLAGS		:= -Wall -pedantic -std=c17
CC			:= g++
C			:= gcc
AR			:= ar
RANLIB		:= ranlib
ARFLAGS		:= -crs
MKDIR		:= mkdir -p
RM			:= rm -f -r
SRC			:= src
OBJ			:= obj
INCL		:= incl

ifdef DEBUG
	CCFLAGS += -g
else
	CCFLAGS += -O3
endif


ALLCPPS		:= $(shell find $(SRC) -type f -iname *.cpp)
ALLCS		:= $(shell find $(SRC) -type f -iname *.c)
ALLOBJ		:= $(foreach F,$(ALLCPPS) $(ALLCS),$(call C2O,$(F)))
ALLINCL		:= $(foreach F,$(ALLCPPS) $(ALLCS),$(call C2H,$(F)))
SUBDIRS		:= $(shell find $(SRC) -type d)
OBJSUBDIRS	:= $(patsubst $(SRC)%,$(OBJ)%,$(SUBDIRS))
INCLSUBDIRS := $(foreach F,$(patsubst $(SRC)%,$(INCL)%,$(SUBDIRS)),-I./$(F))
.PHONY: info

# Generate Static Lib
$(APP) : $(OBJSUBDIRS) $(ALLOBJ)
	$(AR) $(ARFLAGS) $(APP) $(ALLOBJ)
	$(RANLIB) $(APP)

# Generate rules for all objects
$(foreach F,$(ALLCPPS),$(eval $(call COMPILE,$(CC),$(call C2O,$(F)),$(F),$(call C2H,$(F)),$(INCLSUBDIRS),$(CCFLAGS))))
$(foreach F,$(ALLCS),$(eval $(call COMPILE,$(C),$(call C2O,$(F)),$(F),$(call C2H,$(F)),$(INCLSUBDIRS),$(CFLAGS))))

#$(OBJ)/%.o : $(SRC)/%.c
#	$(C) -o $(patsubst $(SRC)%,$(OBJ)%,$@) -c $^ $(CFLAGS)

#$(OBJ)/%.o : $(SRC)/%.cpp
#	$(CC) -o $(patsubst $(SRC)%,$(OBJ)%,$@) -c $^ $(CCFLAGS)

info:
	$(info $(SUBDIRS))
	$(info $(OBJSUBDIRS))
	$(info $(INCLSUBDIRS))
	$(info $(ALLCPPS))
	$(info $(ALLCS))
	$(info $(ALLOBJ))
	$(info $(ALLINCL))

$(OBJSUBDIRS):
	$(MKDIR) $(OBJSUBDIRS)

clean:
	$(RM) $(OBJSUBDIRS)/*.o

cleanall: clean
	$(RM) $(APP)

libs:
	$(MAKE) -C $(LIB)

libs-clean:
	$(MAKE) -C $(LIB) clean

libs-cleanall:
	$(MAKE) -C $(LIB) cleanall

