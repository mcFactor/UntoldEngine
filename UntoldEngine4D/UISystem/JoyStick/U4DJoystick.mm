//
//  U4DJoystick.cpp
//  UntoldEngine
//
//  Created by Harold Serrano on 8/17/13.
//  Copyright (c) 2013 Untold Engine Studios. All rights reserved.
//

#include "U4DJoystick.h"
#include "U4DVector2n.h"
#include "U4DDirector.h"
#include "U4DControllerInterface.h"
#include "U4DSceneManager.h"
#include "U4DScene.h"
#include "U4DNumerical.h"

namespace U4DEngine {
    
    
U4DJoystick::U4DJoystick(std::string uName, float xPosition,float yPosition,const char* uBackGroundImage,float uBackgroundWidth,float uBackgroundHeight,const char* uJoyStickImage):U4DShaderEntity(1.0),isActive(false),controllerInterface(NULL),pCallback(NULL),directionReversal(false),dataPosition(0.0,0.0),dataMagnitude(0.0),touchBeginWithinBoundaryFlag(false){
    
    initJoystickProperties(uName, xPosition, yPosition, uBackgroundWidth, uBackgroundHeight);
    
    setTexture0(uBackGroundImage);
    setTexture1(uJoyStickImage);
    
    setEnableAdditiveRendering(false);
    
    loadRenderingInformation();
}

U4DJoystick::U4DJoystick(std::string uName, float xPosition,float yPosition, float uBackgroundWidth,float uBackgroundHeight):U4DShaderEntity(1.0),isActive(false),controllerInterface(NULL),pCallback(NULL),directionReversal(false),dataPosition(0.0,0.0),dataMagnitude(0.0){
    
    
    initJoystickProperties(uName, xPosition, yPosition, uBackgroundWidth, uBackgroundHeight);
    
    
    loadRenderingInformation();
    
}
    

void U4DJoystick::initJoystickProperties(std::string uName, float xPosition,float yPosition, float uBackgroundWidth,float uBackgroundHeight){
    
     setName(uName);
     
     renderEntity->setPipelineForPass("joystickpipeline",U4DEngine::finalPass);
    
     setShaderDimension(uBackgroundWidth, uBackgroundHeight);

     U4DVector2n translation(xPosition,yPosition);
     
     translateTo(translation);     //move the button
     
     //set controller
     //Get the touch controller
     U4DEngine::U4DSceneManager *sceneManager=U4DEngine::U4DSceneManager::sharedInstance();
     
     controllerInterface=sceneManager->getGameController();
     
     //get the coordinates of the box
     centerPosition.x=getLocalPosition().x;
     centerPosition.y=getLocalPosition().y;
     
     U4DDirector *director=U4DDirector::sharedInstance();
     
     backgroundRadius=uBackgroundWidth/director->getDisplayWidth();;
     joyStickRadius=backgroundRadius/2.0;
     
     //set initial state
     setState(U4DEngine::uiJoystickReleased);
}

U4DJoystick::~U4DJoystick(){

    
}
    

void U4DJoystick::setDataMagnitude(float uValue){
    
    dataMagnitude=uValue;

}

float U4DJoystick::getDataMagnitude(){
    
    return dataMagnitude;

}

void U4DJoystick::update(double dt){
    
    //stateManager->update(dt);
    if(state==U4DEngine::uimoving){
        
        //get previous data
        U4DVector2n previousData=dataPosition;
        
        previousData.normalize();
        //get the direction between previous data and new data
        
        dataPosition=(currentPosition-centerPosition)*(1.0/getShaderWidth());
        
        U4DVector4n param(dataPosition.x,dataPosition.y,0.0,0.0);
        
        updateShaderParameterContainer(0, param);
        
        //remap the current position from [-0.5,0.5] to [-1.0,1.0]
        U4DEngine::U4DVector2n fromRange(-0.5,0.5);
        
        
        U4DEngine::U4DVector2n toRange(-1.0,1.0);
        
        U4DNumerical numerical;
        
        dataPosition.x=numerical.remapValue(dataPosition.x, fromRange, toRange);
        dataPosition.y=numerical.remapValue(dataPosition.y, fromRange, toRange);
        
        dataMagnitude=dataPosition.magnitude();
               
        if (previousData.dot(dataPosition)<0.0) {
            
            directionReversal=true;
            
        }else{
            directionReversal=false;
        }
        
        action();
        
    }else if (state==U4DEngine::uireleased){
        
        U4DVector4n param(0.0,0.0,0.0,0.0);
        
        updateShaderParameterContainer(0, param);
        
        dataPosition=U4DVector2n(0.0,0.0);
        
        dataMagnitude=0.0;
        
        touchBeginWithinBoundaryFlag=false;
    }
    
}

void U4DJoystick::action(){
    
    CONTROLLERMESSAGE controllerMessage;
    
    controllerMessage.elementUIName=getName();
    
    controllerMessage.inputElementType=U4DEngine::uiJoystick;
    
    if (getIsActive()) {

        controllerMessage.inputElementAction=U4DEngine::uiJoystickMoved;

        U4DEngine::U4DVector2n joystickDirection=getDataPosition();

        if (getDirectionReversal()) {

            controllerMessage.joystickChangeDirection=true;

        }else{

            controllerMessage.joystickChangeDirection=false;

        }

        controllerMessage.joystickDirection=joystickDirection;
        
    }else {

       controllerMessage.inputElementAction=U4DEngine::uiJoystickReleased;

    }

    if (pCallback!=nullptr) {
        
        pCallback->action();
    
    }else{
    
        controllerInterface->getGameLogic()->receiveUserInputUpdate(&controllerMessage);
    
    }
    
}

bool U4DJoystick::changeState(INPUTELEMENTACTION uInputAction, U4DVector2n uPosition){
    
    bool withinBoundary=false;
    
    U4DVector2n pos(uPosition.x,uPosition.y);
    
    U4DVector2n distance=(pos-centerPosition);
    
    float distanceMagnitude=distance.magnitude();
    
    if (distanceMagnitude<(backgroundRadius-joyStickRadius)){
        
        currentPosition=uPosition;
        
        withinBoundary=true;
        
        
    }else if(distanceMagnitude>=(backgroundRadius-joyStickRadius) && distanceMagnitude<backgroundRadius) {
        
        currentPosition=centerPosition+distance*(backgroundRadius-joyStickRadius)/distanceMagnitude;
        
        withinBoundary=true;
        
       
    }else if(distanceMagnitude>backgroundRadius && uInputAction==U4DEngine::ioTouchesEnded){
        
        withinBoundary=false;
        
        changeState(U4DEngine::uireleased);
        
    }else if(distanceMagnitude>backgroundRadius && distanceMagnitude<3.0*backgroundRadius) {
        
        currentPosition=centerPosition+distance*(backgroundRadius-joyStickRadius)/distanceMagnitude;
        
        withinBoundary=false;
        
    }
    
    if (withinBoundary) {
        
        if (uInputAction==U4DEngine::ioTouchesBegan) {
            
            touchBeginWithinBoundaryFlag=true;
            
            
        }else if(uInputAction==U4DEngine::ioTouchesMoved || uInputAction==U4DEngine::mouseLeftButtonDragged){
        
            changeState(U4DEngine::uimoving);
            
        }else if((uInputAction==U4DEngine::ioTouchesEnded || uInputAction==U4DEngine::mouseLeftButtonReleased) && getState()==U4DEngine::uimoving){
            
            changeState(U4DEngine::uireleased);
            
        }
        
    }else{
        
        if (touchBeginWithinBoundaryFlag) {
            touchBeginWithinBoundaryFlag=false;
            changeState(U4DEngine::uimoving);
            
        }
    }
    
    return withinBoundary;
}

void U4DJoystick::changeState(int uState){
    
    previousState=state;
    
    //set new state
    setState(uState);
    
    switch (uState) {
         
         
        case U4DEngine::uireleased:
            
            action();
            
            break;
            
        case U4DEngine::uimoving:
            
            break;
            
        default:
            break;
    }
    
    
}

int U4DJoystick::getState(){
    
    return state;
    
}

void U4DJoystick::setState(int uState){
    state=uState;
}

void U4DJoystick::setDataPosition(U4DVector2n uData){
    
    dataPosition=uData;
}

U4DVector2n U4DJoystick::getDataPosition(){
    
    return dataPosition;
}
    
bool U4DJoystick::getIsActive(){
    
    return (getState()==U4DEngine::uimoving);
    
}

void U4DJoystick::setCallbackAction(U4DCallbackInterface *uAction){
    
    //set the callback
    pCallback=uAction;
    
}
    
bool U4DJoystick::getDirectionReversal(){
    
    return directionReversal;
    
}
    
}
