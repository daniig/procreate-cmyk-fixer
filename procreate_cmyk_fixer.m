#!/usr/bin/octave

# valores mínimos de tono y saturación para que se considere
# que un píxel debe contener componente magenta
hue_thresh=200;
sat_thresh=3;

mkdir("./convertido");

if(~isfolder("./convertido"))
  printf("No se ha podido crear la subcarpeta \"convertido\".");
else
  ficheros_png=glob("*.png");
  num_ficheros=size(ficheros_png, 1);
  if(num_ficheros==0)
    printf("No se han encontrado ficheros PNG en esta carpeta.");
  else
    for i=1:num_ficheros
      printf(cstrcat(int2str(i), ": ", ficheros_png{i}, "\n"));
      Irgb=imread(ficheros_png{i});
      Ihsv=rgb2hsv(Irgb)*255;
      Icmyk=zeros(size(Ihsv,1),size(Ihsv,2),4);
      Icmyk(:,:,2)=Ihsv(:,:,2); # a mayor saturación, mayor componente magenta
      Icmyk(:,:,4)=-Ihsv(:,:,3).+255; # a menor "valor"/brillo, mayor componente negro
      # eliminación total de componente magenta de píxeles
      # que son totalmente grises o negros:
      hue_ok=(Ihsv(:,:,1)>hue_thresh);
      sat_ok=(Ihsv(:,:,2)>sat_thresh);
      Icmyk_cutoff=Icmyk;
      Icmyk_cutoff(:,:,2)=Icmyk_cutoff(:,:,2).*sat_ok.*hue_ok;
      imwrite(uint8(Icmyk_cutoff),
        strcat("./convertido/", substr(ficheros_png{i},1,-4), "_cmyk.tif"));
    endfor
  endif
endif