# LAIIQAToolbox

[![View LAIIQAToolbox on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://la.mathworks.com/matlabcentral/fileexchange/120218-laiiqatoolbox) [![LAIIQA Toolbox Version](https://img.shields.io/badge/version-2.0.2-blue)]()

---

# Novedades v2.0.2
|Tipo | Nombre | Caracteristicas |
|:---:|:----:|:----:|
|***Método*** |`plotraw` | Para crear gráfico de los datos originales (sin ajuste).|
|***Propiedad***| `rawtitle`| Para el titulo del gráfico generado por el método `plotraw`.|
|***Método***| `plotozonecalc`| Para crear gráfico de barras de los resultados de ozono consumido, residual y total para cada línea de datos.|
|***Propiedad***| `ozonetitle`| Para el titulo del gráfico de barras generado por el método `plotozonecalc`.|
|***Método***| `plotonly`| Para crear gráfico individual o comparativo de datos ajustados (`fixeddata`) y sin ajustar (`rawdata`).|
|***Propiedad***| `onlytitle`| Para el titulo del gráfico generado por el método `plotonly`.
|***Método***| `saveplot`| Para guardar los gráfic|os generados por los métodos `plotraw`, `plotfixed`, `plotonly` y `plotozonecalc`.|
|***Método***| `savedata`| Para guardar los objetos creados con nombre de variable igual que nombre de arhivo.|
|***Método***| `help`| Abre la guía de inicio **`GettingStarted.mlx`**.|

---

# Cambios
- ***Propiedad*** `fixtitle` cambiada a `fixedtitle` para consistencia con los nombres de variable.


# Reparado
- Error en método `savedata`. Nombres de variables de archivo no correspondian.
---

# Descripción
**MATLAB®** **toolbox** para ajustar y graficar los datos de los archivos `.mat` generados del proceso de ozonización en el Laboratorio de Investigación en Ingeniería Química Ambiental (LAIIQA) de ESIQIE - IPN.

![image_1.png](images/image_1.png)


# Requerimientos de Sistema
- MATLAB R2020b o posterior.
- *laiiqatoolbox*

# Instalación
### Métodos de instalación:

1.  Desde **MATLAB®**, ir a pestaña  **Home** > **Add-Ons** > **Get Add-Ons**, en el *Add-Ons Explorer* buscar como **laiiqatoolbox** e instalar (**Recomendado**).
2. Desde la pagina oficial de [MathWorks - File Exchange](https://la.mathworks.com/matlabcentral/fileexchange/120218-laiiqatoolbox), damos click en **Download**. Extraemos archivos y ejecutamos el paquete `laiiqatoolbox.mltbx`. Seguir las indicaciones de instalación.
3.  Desde la página del proyecto en [GitHub - LAIIQAToolbox](https://github.com/TheBiotechScientist/LAIIQAToolbox), descargar el paquete **`laiiqatoolbox.mltbx`**, abrir **Matlab** (*opcional*) y, desde la ubicación del archivo, hacer doble click sobre él y seguir las indicaciones de instalación.

# Caracteristicas

- Programación orientada a objetos.
- Graficado de datos originales (sin ajuste).
- Graficado de datos ajustados (recortados) a una concentración inicial cero (o cercana).
- Acceso a propiedades de grafico: titulo, etiquetas de ejes ***x*** y ***y***, leyenda, grosor de línea, etc.
- Conversión de datos de tiempo del eje ***x*** : `seg`, `min`, `h`.
- Multiselección de archivos para graficar.
- Acceso a variables de datos originales (`rawdata`) y ajustados (`fixeddata`).
- Cálculo de consumo de ozono.
- Acceso a variables de consumo de ozono (`ozonedata`).
- Guardado de grafico en varios formatos: `png`, `jpg`, `jpeg`, `pdf`, `eps`, `svg`, `tif`, `fig`.
- Creación de varios objetos gráficos a la vez.
- Delimitación del tiempo total final, `xf`, para cada linea de datos.
- Posibilidad de ajustar el tiempo total desfazado de la cinética, multiplicando los datos de tiempo por una constante ***k***, con la propiedad `xk`.
- Representación gráfica del cálculo de consumo de ozono para cada linea de datos (gráfico de barras).

# Guía de Inicio
- Para una descripción completa de las funcionalidades del toolbox revisar el [GettingStarted](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fla.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2Fe3e9c913-0b76-4dd7-a533-bc181062bacd%2F95a27303-b242-4f46-b37f-a486a75bc710%2Ffiles%2Fdoc%2FGettingStarted.mlx&embed=web).
- Para un ejemplo más conciso, revisar el [example](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fla.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2Fe3e9c913-0b76-4dd7-a533-bc181062bacd%2F95a27303-b242-4f46-b37f-a486a75bc710%2Ffiles%2Fdoc%2Fexample.mlx&embed=web)
