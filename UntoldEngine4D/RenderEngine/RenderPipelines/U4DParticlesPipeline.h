//
//  U4DParticlesPipeline.hpp
//  UntoldEngine
//
//  Created by Harold Serrano on 1/8/21.
//  Copyright © 2021 Untold Engine Studios. All rights reserved.
//

#ifndef U4DParticlesPipeline_hpp
#define U4DParticlesPipeline_hpp

#include <stdio.h>
#include "U4DRenderPipeline.h"

namespace U4DEngine {

    class U4DParticlesPipeline: public U4DRenderPipeline {
        
    private:
        
    public:
        
        U4DParticlesPipeline(id <MTLDevice> uMTLDevice, std::string uName);
        
        ~U4DParticlesPipeline();

        void initRenderPassTargetTexture();
        
        void initVertexDesc();

        void initRenderPassDesc();
        
        void initRenderPassPipeline();
        
        void initRenderPassAdditionalInfo();
        
        void executePass(id <MTLRenderCommandEncoder> uRenderEncoder, U4DEntity *uEntity);
        
    };

}

#endif /* U4DParticlesPipeline_hpp */
