#version 330 core

// Atributos de fragmentos recebidos como entrada ("in") pelo Fragment Shader.
// Neste exemplo, este atributo foi gerado pelo rasterizador como a
// interpolação da posição global e a normal de cada vértice, definidas em
// "shader_vertex.glsl" e "main.cpp".
in vec4 position_world;
in vec4 normal;

// Posição do vértice atual no sistema de coordenadas local do modelo.
in vec4 position_model;

// Coordenadas de textura obtidas do arquivo OBJ (se existirem!)
in vec2 texcoords;

// Matrizes computadas no código C++ e enviadas para a GPU
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

// Variaveis associadas ao modelo de interpolacao de Gouraud feita no vertex shader
// caso tenha sido determinado na main
uniform bool gouraud_vertex_shading;
in vec3 gouraud_color_vertex_shading;

// Identificador que define qual objeto está sendo desenhado no momento
#define CORACAO          0
#define CEU              1
#define CHAO             2
#define PAREDE_ESQUERDA  3
#define PAREDE_DIREITA   4
#define PAREDE_FRENTE    5
#define PAREDE_ATRAS     6
#define MAO              7
#define CHEGADA          8
#define TROFEU           9
#define CAIXA           10

uniform int object_id;

// Parâmetros da axis-aligned bounding box (AABB) do modelo
uniform vec4 bbox_min;
uniform vec4 bbox_max;

// Variáveis para acesso das imagens de textura
uniform sampler2D TextureImage0;
uniform sampler2D TextureImage1;
uniform sampler2D TextureImage2;
uniform sampler2D TextureImage3;
uniform sampler2D TextureImage4;
uniform sampler2D TextureImage5;

// O valor de saída ("out") de um Fragment Shader é a cor final do fragmento.
out vec3 color;

// Constantes
#define M_PI   3.14159265358979323846
#define M_PI_2 1.57079632679489661923

void main()
{
    if (gouraud_vertex_shading){

        // Se usar a interpolação de Gouraud é considerada a cor calculada no vertex shader
        color = gouraud_color_vertex_shading;

    } else {
        // Caso não usar a interpolação de Gouraud, é necessário realizar as operações necessárias 
        // para a interpolação de Phong

        // Obtemos a posição da câmera utilizando a inversa da matriz que define o
        // sistema de coordenadas da câmera.
        vec4 origin = vec4(0.0, 0.0, 0.0, 1.0);
        vec4 camera_position = inverse(view) * origin;

        // O fragmento atual é coberto por um ponto que percente à superfície de um
        // dos objetos virtuais da cena. Este ponto, p, possui uma posição no
        // sistema de coordenadas global (World coordinates). Esta posição é obtida
        // através da interpolação, feita pelo rasterizador, da posição de cada
        // vértice.
        vec4 p = position_world;

        // Normal do fragmento atual, interpolada pelo rasterizador a partir das
        // normais de cada vértice.
        vec4 n = normalize(normal);

        // Vetor que define o sentido da fonte de luz em relação ao ponto atual.
        vec4 l = normalize(vec4(1.0,1.0,0.5,0.0));

        // Vetor que define o sentido da câmera em relação ao ponto atual.
        vec4 v = normalize(camera_position - p);

        // Half-vector para o modelo de iluminação de Blinn-Phong
        vec4 hv = normalize(l + v);

        // Coordenadas de textura U e V
        float U = 0.0;
        float V = 0.0;

        // Parâmetros que definem as propriedades espectrais da superfície
        vec3 Kd = vec3(0.0, 0.0, 0.0); // Refletância difusa
        vec3 Ks = vec3(0.0, 0.0, 0.0); // Refletância especular
        float q = 1; // Expoente especular para o modelo de iluminação de Blinn-Phong
        
        if ( object_id > 0  )
        {
            // Coordenadas de textura do plano, obtidas do arquivo OBJ.
            U = texcoords.x;
            V = texcoords.y;
        }

        // Obtemos a refletância difusa a partir da leitura da imagem TextureImage0
        Ks = vec3(0.0, 0.0, 0.0);
        vec3 Kd0 = texture(TextureImage0, vec2(U,V)).rgb;
        vec3 Kd1 = texture(TextureImage1, vec2(U,V)).rgb;
        vec3 Kd2 = texture(TextureImage2, vec2(U,V)).rgb;
        vec3 Kd3 = texture(TextureImage3, vec2(U,V)).rgb;
        vec3 Kd4 = texture(TextureImage4, vec2(U,V)).rgb;
        vec3 Kd5 = texture(TextureImage5, vec2(U,V)).rgb;

        // Equação de Iluminação
        float lambert = max(0,dot(n,l));

        // corações
        if ( object_id == 0 )
        {
            color =  Kd0 * (1 - pow(lambert, 0.2)) + Kd0 * (lambert + 0.01);
        }

        // céu
        else if ( object_id == 1 )
        {
            color = Kd1 * (1 - pow(lambert, 0.2)) + Kd1 * (lambert + 0.01);
        }

        // chão
        else if ( object_id == 2 )
        {
            color = Kd2 * (1 - pow(lambert, 0.2)) + Kd2 * (lambert + 0.01);
        }

        // paredes
        else if ( object_id == 3 || object_id == 4 || object_id == 5 || object_id == 6)
        {
            color = Kd3 * (1 - pow(lambert, 0.2)) + Kd3 * (lambert + 0.01);
        }
    
        //mão
        else if ( object_id == 7 )
        {
            color = Kd4 * (1 - pow(lambert, 0.2)) + Kd4 * (lambert + 0.01);
        }
        
        //troféu
        else if ( object_id == 9 )
        {
            color = Kd5 * (1 - pow(lambert, 0.2)) + Kd5 * (lambert + 0.01);
        }

        // Veja https://en.wikipedia.org/w/index.php?title=Gamma_correction&oldid=751281772#Windows.2C_Mac.2C_sRGB_and_TV.2Fvideo_standard_gammas
    }
    color = pow(color, vec3(1.0,1.0,1.0)/2.2);
}
