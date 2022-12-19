#version 410 core

layout (location = 0) in vec3 a_Position;
layout (location = 1) in vec2 a_LocalPosition;
layout (location = 2) in vec4 a_Color;
layout (location = 3) in vec2 a_Thickness;
layout (location = 4) in vec2 a_Fade;

uniform mat4 u_ProjView;

out vec2 v_LocalPosition;
out vec4 v_Color;
out vec2 v_Thickness;
out vec2 v_Fade;

void main()
{
    v_LocalPosition = a_LocalPosition;
    v_Color = a_Color;
    v_Thickness = a_Thickness;
    v_Fade = a_Fade;
    gl_Position = u_ProjView * vec4(a_Position, 1.0);
}
