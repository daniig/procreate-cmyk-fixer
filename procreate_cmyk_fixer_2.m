#!/usr/bin/octave

clear all

# índices
C = 1;
M = 2;
Y = 3;
K = 4;

# si la diferencia entre cian-magenta o amarillo-magenta supera este umbral,
# es que el píxel no es gris (contiene color)
gray_thresh_cm = -uint8(20);
gray_thresh_ym = gray_thresh_cm*0.9;
# si cian o amarillo superan este umbral, es que están aportando gris
extra_key_thresh = 90;

mkdir("./convertido2");

if(~isfolder("./convertido2"))
  printf("No se ha podido crear la subcarpeta \"convertido\".");
else
  ficheros_in=glob("*.tiff");
  # ficheros_in{1} = "test.tiff";
  num_ficheros=size(ficheros_in, 1);
  if(num_ficheros==0)
    printf("No se han encontrado ficheros PNG en esta carpeta.");
  else
    for i=1:num_ficheros
      printf(cstrcat(int2str(i), ": ", ficheros_in{i}, "\n"));
      
      I_cmyk_pro = double(imread(ficheros_in{i}));
      d_cm = I_cmyk_pro(:,:,C)-I_cmyk_pro(:,:,M);
      d_ym = I_cmyk_pro(:,:,Y)-I_cmyk_pro(:,:,M);
      is_gray = ((d_cm > gray_thresh_cm) | (d_ym > gray_thresh_ym)) | ...
                ((d_cm > 0) | (d_ym > 0));

      key = zeros(size(I_cmyk_pro,C),size(I_cmyk_pro,M));
      key(is_gray) = I_cmyk_pro(:,:,M)(is_gray);
      key(!is_gray) = I_cmyk_pro(:,:,K)(!is_gray);

      # aportación extra de key: necesario en algunos píxeles en la frontera del
      # color con la línea negra
      extra_key = ( (I_cmyk_pro(:,:,C) > extra_key_thresh) |   ...
                    (I_cmyk_pro(:,:,Y) > extra_key_thresh)) &  ...
                  (!is_gray);
      key(extra_key) = key(extra_key) + 0.3*(I_cmyk_pro(:,:,C)(extra_key) + I_cmyk_pro(:,:,Y)(extra_key));

      # todavía falta añadir una aportación más del negro:
      # en aquellos píxeles que son grises (is_gray) pero que además tienen key no nulo
      key(is_gray) = key(is_gray) + 0.3*I_cmyk_pro(:,:,K)(is_gray);

      magenta = zeros(size(I_cmyk_pro,C),size(I_cmyk_pro,M));
      magenta(!is_gray) = I_cmyk_pro(:,:,M)(!is_gray);

      I_cmyk_clean = zeros(size(I_cmyk_pro,C),size(I_cmyk_pro,M),4);
      I_cmyk_clean(:,:,M) = magenta;
      I_cmyk_clean(:,:,K) = key;

      imwrite(uint8(I_cmyk_clean),
        strcat("./convertido2/", substr(ficheros_in{i},1,-5), "_mk.tif"));
    endfor
  endif
endif