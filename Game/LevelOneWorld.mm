//
//  LevelOneWorld.cpp
//  UntoldEngine
//
//  Created by Harold Serrano on 5/26/13.
//  Copyright (c) 2013 Untold Engine Studios. All rights reserved.
//

#include "LevelOneWorld.h"
#include <stdio.h>
#include "CommonProtocols.h"
#include "U4DDirector.h"
#include "U4DCamera.h"
#include "U4DLights.h"
#include "U4DSkybox.h"
#include "U4DResourceLoader.h"
#include "U4DFontLoader.h"
#include "U4DLayerManager.h"
#include "U4DText.h"
#include "U4DLogger.h"
#include "UserCommonProtocols.h"
#include "U4DCameraInterface.h"
#include "U4DCameraThirdPerson.h"
#include "U4DCameraFirstPerson.h"
#include "U4DCameraBasicFollow.h"
#include "MobileLayer.h"
#include "Ball.h"



using namespace U4DEngine;

void LevelOneWorld::init(){
    
    /*----DO NOT REMOVE. THIS IS REQUIRED-----*/
    //Configures the perspective view, shadows, lights and camera.
    setupConfiguration();
    /*----END DO NOT REMOVE.-----*/
    
    //The following code snippets loads scene data, renders the characters and skybox.
    
    /*---LOAD SCENE ASSETS HERE--*/
    //The U4DResourceLoader is in charge of loading the binary file containing the scene data
    U4DEngine::U4DResourceLoader *resourceLoader=U4DEngine::U4DResourceLoader::sharedInstance();
    
    //Load binary file with scene data
    resourceLoader->loadSceneData("soccergame.u4d");

    //Load binary file with texture data
    resourceLoader->loadTextureData("soccerTextures.u4d");
    
    //Animation for astronaut
    //load binary file with animation data
    resourceLoader->loadAnimationData("runningAnimation.u4d");

    resourceLoader->loadAnimationData("idleAnimation.u4d");
    
    resourceLoader->loadAnimationData("rightdribbleAnimation.u4d");
    
    resourceLoader->loadAnimationData("rightsolehaltAnimation.u4d");
    
    resourceLoader->loadAnimationData("rightpassAnimation.u4d");
    
    //RENDER THE MODELS
    
    //render the ground
    ground=new U4DEngine::U4DGameObject();

    if(ground->loadModel("field")){

        //set shadows
        ground->setEnableShadow(true);
        
        ground->setNormalMapTexture("FieldNormalMap.png");
        
        //send info to gpu
        ground->loadRenderingInformation();

        //add to scenegraph
        addChild(ground);
    }
    
    
    U4DEngine::U4DGameObject *ads[5];
    
    for(int i=0;i<sizeof(ads)/sizeof(ads[0]);i++){

        std::string name="ad";

        name+=std::to_string(i);

        ads[i]=new U4DEngine::U4DGameObject();

        if(ads[i]->loadModel(name.c_str())){

            ads[i]->setEnableShadow(true);

            ads[i]->loadRenderingInformation();

            addChild(ads[i]);
        }

    }
    
    U4DEngine::U4DGameObject *bleachers[11];
    
    for(int i=0;i<sizeof(bleachers)/sizeof(bleachers[0]);i++){

        std::string name="bleacher";

        name+=std::to_string(i);

        bleachers[i]=new U4DEngine::U4DGameObject();

        if(bleachers[i]->loadModel(name.c_str())){

            bleachers[i]->setEnableShadow(true);

            bleachers[i]->loadRenderingInformation();

            addChild(bleachers[i]);
        }

    }
    
    U4DEngine::U4DGameObject *fieldGoals[2];
    
    for(int i=0;i<sizeof(fieldGoals)/sizeof(fieldGoals[0]);i++){

        std::string name="fieldgoal";

        name+=std::to_string(i);

        fieldGoals[i]=new U4DEngine::U4DGameObject();

        if(fieldGoals[i]->loadModel(name.c_str())){

            fieldGoals[i]->setEnableShadow(true);

            fieldGoals[i]->loadRenderingInformation();

            addChild(fieldGoals[i]);
        }

    }
    
    //render the ball
    Ball *ball=Ball::sharedInstance();
    
    if (ball->init("ball")) {
        
        addChild(ball);
        
    }
    

    //create the player object and render it
    
    Player *players[3];
    
    for(int i=0;i<sizeof(players)/sizeof(players[0]);i++){
        
        std::string name="player";
        name+=std::to_string(i);
        
        players[i]=new Player();
        
        if(players[i]->init(name.c_str())){
            
            addChild(players[i]);
            
            players[i]->changeState(idle);
            
            teammates.push_back(players[i]);
        }
    }
    
    //add teammates
    for(int i=0;i<sizeof(players)/sizeof(players[0]);i++){
        players[i]->addTeammates(teammates);
    }
    
    players[0]->changeState(arrive);
    

    shader=new U4DEngine::U4DShaderEntity();

    shader->setShader("vertexRadarShader","fragmentRadarShader");

    shader->setTexture0("radarfield.png");
    
    shader->setShaderDimension(200.0, 113.0);

    shader->translateTo(0.0, -0.7, 0.0);
    
    shader->loadRenderingInformation();

    addChild(shader,-10);
    
    
    
    
    /*---CREATE SKYBOX HERE--*/
//    U4DEngine::U4DSkybox *skybox=new U4DEngine::U4DSkybox();
//
//    skybox->initSkyBox(20.0,"spacemarsLF.png","spacemarsRT.png","spacemarsUP.png","spacemarsDN.png","spacemarsFT.png", "spacemarsBK.png");
//
//    skybox->translateBy(0.0,20.0,0.0);
//
//    addChild(skybox,0);
//
//    U4DEngine::U4DDirector *director=U4DEngine::U4DDirector::sharedInstance();
//
//    if (director->getDeviceOSType()==U4DEngine::deviceOSIOS) {
//
//        //Create Mobile Layer with buttons & joystic
//        U4DEngine::U4DLayerManager *layerManager=U4DEngine::U4DLayerManager::sharedInstance();
//
//        //set the world (view component) for the layer manager --MAY WANT TO FIX THIS. DONT LIKE SETTING THE VIEW HERE FOR THE LAYER MANAGER
//        layerManager->setWorld(this);
//
//        //create the Mobile Layer
//        MobileLayer *mobileLayer=new MobileLayer("mobilelayer");
//
//        mobileLayer->init();
//
//        mobileLayer->setPlayer(player);
//
//        layerManager->addLayerToContainer(mobileLayer);
//
//        layerManager->pushLayer("mobilelayer");
//
//    }else if(director->getDeviceOSType()==U4DEngine::deviceOSMACX){
//
//        /*---CREATE TEXT HERE--*/
//        //Create a Font Loader object
//        U4DEngine::U4DFontLoader *fontLoader=new U4DEngine::U4DFontLoader();
//
//        //Load font data into the font loader object. Such as the xml file and image file
//        fontLoader->loadFontAssetFile("myFont.xml", "myFont.png");
//
//        //Create a text object. Provide the font loader object and the spacing between letters
//        U4DEngine::U4DText *myText=new U4DEngine::U4DText(fontLoader, 30);
//
//        //set the text you want to display
//        myText->setText("exit: cmd+w");
//
//        //If desire, set the text position. Remember the coordinates for 2D objects, such as text is [-1.0,1.0]
//        myText->translateTo(0.50, -0.70, 0.0);
//
//        //6. Add the text to the scenegraph
//        addChild(myText,-2);
//
//    }
    
    /*---SET CAMERA BEHAVIOR TO THIRD PERSON--*/
//    //Instantiate the camera
//    U4DEngine::U4DCamera *camera=U4DEngine::U4DCamera::sharedInstance();
//
//    //Line 1. Instantiate the camera interface and the type of camera you desire
//    U4DEngine::U4DCameraInterface *cameraThirdPerson=U4DEngine::U4DCameraThirdPerson::sharedInstance();
//
//    //Line 2. Set the parameters for the camera. Such as which model the camera will target, and the offset positions
//    cameraThirdPerson->setParameters(player,0.0,2.0,10.0);
//
//    //Line 3. set the camera behavior
//    camera->setCameraBehavior(cameraThirdPerson);

    //Instantiate the camera
//    U4DEngine::U4DCamera *camera=U4DEngine::U4DCamera::sharedInstance();
//
//    //Line 1. Instantiate the camera interface and the type of camera you desire
//    U4DEngine::U4DCameraInterface *cameraFirstPerson=U4DEngine::U4DCameraFirstPerson::sharedInstance();
//
//    //Line 2. Set the parameters for the camera. Such as which model the camera will target, and the offset positions
//    cameraFirstPerson->setParameters(player,0.0,0.5,0.5);
//
//    //Line 3. set the camera behavior
//    camera->setCameraBehavior(cameraFirstPerson);
    
    //Instantiate the camera
    U4DEngine::U4DCamera *camera=U4DEngine::U4DCamera::sharedInstance();

    //Instantiate the camera interface and the type of camera you desire
    U4DEngine::U4DCameraInterface *cameraBasicFollow=U4DEngine::U4DCameraBasicFollow::sharedInstance();

    //Set the parameters for the camera. Such as which model the camera will target, and the offset positions
    cameraBasicFollow->setParameters(ball,0.0,16.0,-25.0);

    //set the camera behavior
    camera->setCameraBehavior(cameraBasicFollow);
    
}

void LevelOneWorld::update(double dt){
    
    //get the ball position
    Ball *ball=Ball::sharedInstance();
    
    U4DEngine::U4DVector2n ballPosition(ball->getAbsolutePosition().x,ball->getAbsolutePosition().z);
    
    ballPosition.x/=80.0;
    ballPosition.y/=47.0;
    
    U4DVector4n param0(ballPosition.x,ballPosition.y,0.0,0.0);
    shader->updateShaderParameterContainer(0, param0);
    
    //index used for the shader entity container
    int index=1;
    
    for(const auto &n:teammates){
        
        U4DEngine::U4DVector2n playerPos(n->getAbsolutePosition().x,n->getAbsolutePosition().z);

        playerPos.x/=80.0;
        playerPos.y/=47.0;

        U4DVector4n param(playerPos.x,playerPos.y,0.0,0.0);
        shader->updateShaderParameterContainer(index, param);
        
        index++;
    }
    
}

void LevelOneWorld::setupConfiguration(){
    
    //Get director object
    U4DDirector *director=U4DDirector::sharedInstance();
    
    //Compute the perspective space matrix
    U4DEngine::U4DMatrix4n perspectiveSpace=director->computePerspectiveSpace(45.0f, director->getAspect(), 0.01f, 400.0f);
    director->setPerspectiveSpace(perspectiveSpace);
    
    //Compute the orthographic shadow space
    U4DEngine::U4DMatrix4n orthographicShadowSpace=director->computeOrthographicShadowSpace(-100.0f, 100.0f, -100.0f, 100.0f, -100.0f, 100.0f);
    director->setOrthographicShadowSpace(orthographicShadowSpace);
    
    //Get camera object and translate it to position
    U4DEngine::U4DCamera *camera=U4DEngine::U4DCamera::sharedInstance();
    U4DEngine::U4DVector3n cameraPosition(0.0,16.0,-25.0);
    
    //translate camera
    camera->translateTo(cameraPosition);
    
    //set origin point
    U4DVector3n origin(0,0,0);
    
    //Create light object, translate it and set diffuse and specular color
    U4DLights *light=U4DLights::sharedInstance();
    light->translateTo(50.0,50.0,-50.0);
    U4DEngine::U4DVector3n diffuse(0.5,0.5,0.5);
    U4DEngine::U4DVector3n specular(0.2,0.2,0.2);
    light->setDiffuseColor(diffuse);
    light->setSpecularColor(specular);
    
    addChild(light);
    
    //Set the view direction of the camera and light
    camera->viewInDirection(origin);
    
    light->viewInDirection(origin);
    
    //set the poly count to 5000. Default is 3000
    director->setPolycount(5000);
    
}

LevelOneWorld::~LevelOneWorld(){
    
    delete ground;
    
}




