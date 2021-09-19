//
//  U4DPointLight.cpp
//  UntoldEngine
//
//  Created by Harold Serrano on 1/22/21.
//  Copyright © 2021 Untold Engine Studios. All rights reserved.
//

#include "U4DPointLight.h"
#include "Constants.h"
#include "U4DLogger.h"

namespace U4DEngine{

    U4DPointLight* U4DPointLight::instance=0;

    U4DPointLight::U4DPointLight(){
        setEntityType(U4DEngine::LIGHT);
    };

    U4DPointLight::~U4DPointLight(){
        
    };

    U4DPointLight* U4DPointLight::sharedInstance(){
        
        if (instance==0) {
            instance=new U4DPointLight();
        }
        
        return instance;
    }

    void U4DPointLight::addLight(U4DVector3n &uLightPosition, U4DVector3n &uDiffuseColor, float uConstantAtten, float uLinearAtten, float uExpAtten,float energy, float falloutDistance){
      
        if(pointLightsContainer.size()<U4DEngine::maxNumberOfLights){
            
            POINTLIGHT pointLight;
            
            pointLight.position=uLightPosition;
            pointLight.diffuseColor=uDiffuseColor;
            pointLight.constantAttenuation=uConstantAtten;
            pointLight.linearAttenuation=uLinearAtten;
            pointLight.expAttenuation=uExpAtten;
            pointLight.energy=energy;
            pointLight.falloutDistance=falloutDistance;
            
            pointLightsContainer.push_back(pointLight);
            
        }else{
            
            U4DLogger *logger=U4DLogger::sharedInstance();
            
            logger->log("Error: Could not add additional light. Max number of lights is 100.");
            
        }
        
    }

}
