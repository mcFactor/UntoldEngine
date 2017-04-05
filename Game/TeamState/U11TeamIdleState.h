//
//  U11TeamIdleState.hpp
//  UntoldEngine
//
//  Created by Harold Serrano on 4/4/17.
//  Copyright © 2017 Untold Game Studio. All rights reserved.
//

#ifndef U11TeamIdleState_hpp
#define U11TeamIdleState_hpp

#include <stdio.h>
#include "UserCommonProtocols.h"
#include "U11TeamStateInterface.h"

class U11Team;

class U11TeamIdleState:public U11TeamStateInterface {
    
private:
    
    U11TeamIdleState();
    
    ~U11TeamIdleState();
    
public:
    
    static U11TeamIdleState *instance;
    
    static U11TeamIdleState *sharedInstance();
    
    void enter(U11Team *uTeam);
    
    void execute(U11Team *uTeam, double dt);
    
    void exit(U11Team *uTeam);
    
    bool handleMessage(U11Team *uTeam, Message &uMsg);
};
#endif /* U11TeamIdleState_hpp */
