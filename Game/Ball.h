//
//  Ball.hpp
//  UntoldEngine
//
//  Created by Harold Serrano on 11/10/21.
//  Copyright © 2021 Untold Engine Studios. All rights reserved.
//

#ifndef Ball_hpp
#define Ball_hpp

#include <stdio.h>
#include "U4DModel.h"
#include "U4DDynamicAction.h"
#include "UserCommonProtocols.h"


class Ball:public U4DEngine::U4DModel {
    
private:
    
    static Ball* instance;
    
    //state of the character
    int state;
    
    //previous state of the character
    int previousState;
    
    float kickMagnitude;
    
    U4DEngine::U4DVector3n kickDirection;
    
    U4DEngine::U4DVector3n motionAccumulator;
   
protected:
    
    //constructor
    Ball();
    //destructor
    
    ~Ball();
    
public:
    
    U4DEngine::U4DDynamicAction *kineticAction;
    
    U4DEngine::U4DVector3n homePosition;
    
    static Ball* sharedInstance();
    
    //init method. It loads all the rendering information among other things.
    bool init(const char* uModelName);
    
    void update(double dt);
    
    void applyForce(float uFinalVelocity, double dt);
    
    void applyVelocity(U4DEngine::U4DVector3n &uFinalVelocity, double dt);
    
    void applyRoll(float uFinalVelocity,double dt);
    
    void decelerate(double dt);
    
    void setState(int uState);
    
    int getState();
    
    int getPreviousState();
    
    void changeState(int uState);
    
    void setKickBallParameters(float uKickMagnitude,U4DEngine::U4DVector3n &uKickDirection);

    U4DEngine::U4DVector3n predictPosition(double dt, float uTimeScale);
    
    float timeToCoverDistance(U4DEngine::U4DVector3n &uFinalPosition);

    bool aiScored;
};

#endif /* Ball_hpp */
