//
//  CustomShader.metal
//  arsimplesea
//
//  Created by Yasuhito NAGATOMO on 2022/03/16.
//

#include <metal_stdlib>
#include <RealityKit/RealityKit.h>
using namespace metal;

[[visible]]
void waveGeometryModifier(realitykit::geometry_parameters params)
{
    float3 pos = params.geometry().model_position();
    // x axis: wave length = 0.2 [m], cycle = 8.0 [sec]
    // z axis: wave length = 0.3 [m], cycle = 10.0 [sec]
    // wave height = +/- 0.005 [m]
    float3 offset = float3(0.0,
                           cos( 3.14 * 2.0 * pos.x / 0.2 + 3.14 * 2.0 * params.uniforms().time() / 8.0 )
                         * cos( 3.14 * 2.0 * pos.z / 0.3 + 3.14 * 2.0 * params.uniforms().time() / 10.0 ) * 0.005,
                           0.0);
    params.geometry().set_model_position_offset(offset);
}
