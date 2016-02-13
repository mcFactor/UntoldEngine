//
//  Earth.cpp
//  UntoldEngine
//
//  Created by Harold Serrano on 5/26/13.
//  Copyright (c) 2013 Untold Story Studio. All rights reserved.
//

#include "Earth.h"

#include "CommonProtocols.h"

#include <stdio.h>

#include "U4DDirector.h"

#include "MyCharacter.h"
#include "U4DBoundingAABB.h"
#include "U4DMatrix3n.h"
#include "U4DImage.h"
#include "U4DMultiImage.h"
#include "U4DButton.h"
#include "U4DSkyBox.h"
#include "U4DTouches.h"
#include "U4DCamera.h"
#include "U4DControllerInterface.h"

#include "GameController.h"
#include "U4DSprite.h"
#include "U4DSpriteLoader.h"


#include "U4DFont.h"
#include "U4DBoundingSphere.h"
#include "U4DBoundingOBB.h"
#include "U4DBoundingVolume.h"
#include "U4DBoundingAABB.h"

#include "U4DDigitalAssetLoader.h"
#include "U4DFontLoader.h"
#include "U4DLights.h"
#include "U4DDebugger.h"
#include "U4DAnimation.h"
#include "U4DSpriteAnimation.h"
#include "Town.h"
#include "U4DPlane.h"
#include "U4DOBB.h"
#include "U4DPoint3n.h"
#include "U4DTetrahedron.h"
#include "U4DSegment.h"
#include "U4DTriangle.h"
#include "U4DConvexPolygon.h"

void Earth::init(){
    
    //U4DDebugger *debugger=new U4DDebugger();
    
    U4DEngine::U4DCamera *camera=U4DEngine::U4DCamera::sharedInstance();
    camera->translateBy(0.0, -2.0, -7.0);
    //camera->rotateBy(10.0,-15.0,0.0);
    
    setName("earth");
    
    enableGrid(true);
    
    U4DEngine::U4DVector3n gravity(0,-10,0);
    //Set gravity here
    setGravity(gravity);
    
    //create our object
    cube=new Town();
    cube->init("Cube",0.0,5.5,0.0);
    cube->setName("falling");

    
    
    //cube->rotateBy(40.0, 20.0, 260.0);
    
    cube->setMass(1.0);
    U4DEngine::U4DVector3n centerOfMass(0.0,0,0);
    
    cube->setCenterOfMass(centerOfMass);
    cube->setShader("simpleRedShader");
    
    //Apply physics engine to the object
    cube->applyPhysics(true);
    
    //Apply the collision engine to the object
    cube->enableCollision();
    
    //set the coefficient of restitution to 0.8
    cube->setCoefficientOfRestitution(0.8);
    
    cube->setBroadPhaseBoundingVolumeVisibility(true);
    
    
    
    addChild(cube);
    
   
    cube2=new Town();
    cube2->init("Cube",0.0,0,0.0);
    cube2->setShader("simpleShader");
    cube2->setName("static");
    //cube2->rotateBy(0.0, 0.0, -60.0);
    
    //cube2->applyPhysics(true);
    
    cube2->enableCollision();
    cube2->setBroadPhaseBoundingVolumeVisibility(true);
    

    
    addChild(cube2);
    
    
    
    /*
    
    // ADD Gravity
    
    
    Town *cube=new Town();
    cube->init("Cube", 0, 5, 0);
    cube->setShader("simpleShader");
    cube->applyPhysics(true);
    
    addChild(cube);
    
     */
    
   
     /*
     //SHOW SHADOWS
     
     enableShadows();
    
    
    fort=new Town();
    fort->init("fort",0.0,0.0,0.0);
    fort->setName("fort");
    
    Town *floor=new Town();
    floor->init("floor", 0.0, 0.0, 0.0);
    
    floor->setName("floor");
    floor->receiveShadows();
    
    addChild(floor);
    addChild(fort);
    
    */
    U4DEngine::U4DLights *light=new U4DEngine::U4DLights();
    
    light->translateTo(-3.0,4.0,-3.0);
    addChild(light);
    
    //debugger->addEntityToDebug(light);
    //addChild(debugger);
    
    
    initLoadingModels();
    
/*
    Town *smallhouse1=new Town();
    smallhouse1->init("smallhouse1", 0, 0, 0);
    
    //addChild(well);
   
    addChild(smallhouse1);
    
    Town *smallhouse2=new Town();
    smallhouse2->init("smallhouse2", -3.5, 0, 0);
    
    addChild(smallhouse2);
    
    Town *littlemansion=new Town();
    littlemansion->init("littlemansion", 0, 0, 3);
    
    addChild(littlemansion);
    
    robot=new MyCharacter();
    
    robot->init("UEMascot", 0, 0, 0);
    addChild(robot);
    
    U4DLights *light=new U4DLights();
    
    addChild(light);
    
    //debugger->addEntityToDebug(et);
    //debugger->addEntityToDebug(light);
    addChild(debugger);
    
    
    initLoadingModels();
    
    light->translateTo(2.0,2.0,0.0);
    
    //add a skylight
    
    
    U4DSkyBox *skybox=new U4DSkyBox();
    skybox->initSkyBox(20, "RightImage.png", "LeftImage.png", "FrontImage.png", "BackImage.png", "TopImage.png", "BottomImage.png");
    
    skybox->translateTo(0,5,0);
    addChild(skybox);
    */
    
    
    /*
    
     //set the font to use
    U4DFontLoader *arialFont=new U4DFontLoader();
    arialFont->loadFontAssetFile("ArialFont.xml","ArialFont.png");
    
    
    U4DFont *myFont=new U4DFont(arialFont);
    
    myFont->setText("Untold Story Studio");
    
    myFont->translateTo(-0.8,0.0,0.0);
    
    addChild(myFont);
    
    
    U4DSpriteLoader *spriteLoader=new U4DSpriteLoader();
    spriteLoader->loadSpritesAssetFile("spriteExample.xml","spriteExample.png");
    
    
    U4DSprite *sprite=new U4DSprite(spriteLoader);
    sprite->setSprite("sprite2.png");
    addChild(sprite);
   
    
    
    SpriteAnimation spriteAnimation;
    spriteAnimation.animationSprites.push_back("sprite1.png");
    spriteAnimation.animationSprites.push_back("sprite2.png");
    
    spriteAnimation.delay=0.2;
    
    U4DSpriteAnimation *sAnimation=new U4DSpriteAnimation(sprite,spriteAnimation);
    
    sAnimation->start();
    */
    
}

void Earth::update(double dt){

//    U4DEngine::U4DVector3n axix(0,0,1);
//    
//    U4DEngine::U4DQuaternion axisOrientation(rotation,axix);
//    
//    U4DEngine::U4DVector3n axisPosition(-0.5,0.0,0.5);
//    
//    cube->rotateAboutAxis(axisOrientation, axisPosition);
//    
//    rotation++;
//    
//    if (rotation>360) {
//        rotation=0;
//    }
    
}

void Earth::action(){
    
    
    U4DEngine::U4DDirector *director=U4DEngine::U4DDirector::sharedInstance();
    U4DEngine::U4DLights *light=director->getLight();
    setEntityControlledByController(cube);
    
}




