# procreate-cmyk-fixer
Procesa imágenes CMYK de dos tintas para que *realmente* usen solo dos tintas.

**English description below**

Este script de Octave se creó después de comprobar que algunas imágenes dibujadas en [Procreate](https://apps.apple.com/es/app/procreate/id425073498) en lienzos CMYK utilizando solo tonos magentas y negros contenían valores no nulos en los canales de cian y amarillo. Esto es debido a que Procreate siempre utiliza una representación interna en RGB, necesitando de varias conversiones y perdiendo precisión.[1]

¿Por qué esto es un problema? Si la imagen se ha diseñado cuidadosamente en tonos magentas y grises para ser imprimida en un proceso a dos tintas, no debe contener ninguna información en los canales cian y amarillo, ya que no serán impresos y dicha información se perderá.

Para solucionarlo, este script toma las imágenes exportadas desde Procreate en PNG (espacio de color RGB), las transforma al espacio de color HSV y regenera la información de los canales magenta y negro del siguiente modo:

- A mayor saturación de un píxel, mayor componente magenta.
- A menor brillo ("value"), mayor componente negra.
- Algunos tonos de gris estaban representados por colores con poca saturación y tono aparentemente aleatorio. Si el tono no es cercano al magenta (controlado por el umbral `hue_thresh`) y la saturación es baja (controlado por el umbral `sat_thresh`), se considera que dicho píxel solo debe contener información en el canal negro.

El script toma todos los ficheros PNG de la carpeta en la que está siendo ejecutado y los convierte a formato TIFF con representación CMYK. Es posible que aun así la imagen necesite un ajuste en el rango del canal negro, lo cual deberá ser juzgado por el artista para cada imagen.

---

This Octave script was created after noticing that some images drawn on [Procreate](https://apps.apple.com/es/app/procreate/id425073498) on CMYK canvases actually contained non-zero values in both the cyan and yellow channels. This is a result of Procreate's internal representation of images, which is always RGB, causing some loss of precission.[1]

Why is this a problem? If an image has been carefully designed in just shades of magenta and gray in order to be printed using a two-ink process, it must not contain any information in the cyan and yellow channels, since they won't be printed, which will result in a loss of information.

To solve this problem, this script takes images as exported from Procreate in PNG format (which implies an RGB colorspace), transforms them into HSV space and regenerates the magenta and key information like so:

- The more saturated a pixel is, the higher the magenta component.
- The lower the brightness ("value"), the higher the key component.
- Some shades of gray were represented by colors low in saturation and with a seemingly random hue. If the hue of a pixel is far from magenta (as controlled by the `hue_thresh` variable) and the saturation is low (as controlled by `sat_thresh`), that pixel is treated as having only a black (key) component.

The script takes every PNG file in the folder it's being run from and converts them to TIFF format with CMYK representation. The resulting images might still need a black range adjustment, which should be carried out by the artist on a per-image basis.


[1]: https://folio.procreate.art/discussions/4/10/34838
