Shader "Sprites/Clipping"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _ViewPort ("View Port (World)", Vector) = (0, 0, 0, 0)
    }
 
 	SubShader
 	{
		Tags
		{ 
			"Queue" = "Transparent" 
			"IgnoreProjector" = "True" 
			"RenderType" = "Transparent" 
			"PreviewType" = "Plane"
			"CanUseSpriteAtlas" = "True"
		}
	 
	 	Cull Off
		Lighting Off
		ZWrite Off
		Fog { Mode Off }
		Blend SrcAlpha OneMinusSrcAlpha
	 
        CGPROGRAM
        #pragma surface surf NoLighting alpha
        
	sampler2D _MainTex;
	float4    _ViewPort;	
				        
	struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

 	fixed4 LightingNoLighting(SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
	        fixed4 c;
        
    	        c.rgb = s.Albedo; 
        	c.a = s.Alpha;
                        
        	return c;
        }

		void surf (Input IN, inout SurfaceOutput o)
		{
			float2 worldPos = IN.worldPos.xy;
			
			bool isVerticalClipping = (worldPos.x < _ViewPort.x || worldPos.x > (_ViewPort.x + _ViewPort.z));
			bool isHorizontalClipping = (worldPos.y < _ViewPort.y || worldPos.y > (_ViewPort.y + _ViewPort.w));
			
			if (isVerticalClipping == false && isHorizontalClipping == false)
			{
				fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			
				o.Albedo = c.rgb;
				o.Alpha = c.a;
			}
			else
			{
				o.Albedo = 0;
				o.Alpha = 0;
			}
		}
			
        ENDCG
	}
}
