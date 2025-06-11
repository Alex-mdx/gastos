# Control de gastos
## Descripción
Proyecto personal para el manejo de gastos personales, usando datos locales partiendo del SQLite, para persistencia de datos, y calculo de gastos partiendo de rango de fechas, presupuesto por semana y/o por día, así como evidencia fotográfica y uso de calendario para la mejor visualización de estos mismos, para un mejor y excelente control de gastos por persona.

## Change Log
### Versión 0.1.4 (actualización próxima)
#### Correcciones 🔧
- Fecha de ingreso corregida, ahora cuando seleccione una fecha diferente a la actual, tomara siempre la hora actual, evitando que guarde a la hora 00:00:00.
- Tabla de evidencias en el guardado de gastos para una persistencia de datos.
#### Mejoras 📈
- Interfaz grafica reordenada
- Colorizado de interfaz mejorado.
- Orden de tarjeta de gasto mejorada.
- Notas de gasto mejoradas.
- Optimización en el historial de gasto.
- Optimización en visualización de promedios por día y semanal al seleccionar el botón de promedio personalizado.
- Calidad de imagen en evidencia.
- Respaldo manual de datos de app reconstruido a un zip.
- Evidencia convertida a foto.
- Al habilitar los presupuestos, el botón de cambio muestra una barra de porcentaje respectivo al sobrante del presupuesto.
#### Implementaciones 🆕
  - Implementación de **Método de pago**, por defecto estará el efectivo, se podrán crear mas, con su respectiva denominación.
  - Botón de visualización de evidencias generales desde la pantalla principal de gastos.
  - Conexión con **Dropbox** para respaldo de información total en la nube.
  - **Bidones de presupuesto**, crea un sub presupuesto enlazado a su categoría de gasto o su método de gasto que se vacía y se vuelve a rellenar dependiendo de su configuración.
  - Tema oscuro y claro activable.
  - Graficas de gastos integradas su consumo.
  ---
### Versión 0.1.3
  - Mejora al navegar por el calendario
  - Corrección al momento de editar su imagen (la rueda de carga no desaparecía).
---
### Versión 0.1.2
  - Corrección al instalar la app, que no se encontraba en los archivos del teléfono.
  - Corrección al momento de editar su imagen.
---
### Versión 0.1.1
  - Corrección de la palabra ~~galleria~~ a Galería ಠ~ಠ.
  - Corrección de diseño y optimización en la tarjeta de gastos.
  - Corrección de visualización de gastos en el historial.
  - Implementación de edición de foto de evidencia.
  - Implementación de vista de cambio de gasto actual en función al gasto limite al tocar el **limite %**.
  - Implementación del botón "Eliminar datos", usando autentificación biométrica local del dispositivo.
  - Optimización en la obtención de datos en el historial de gastos.
  - **Opción habilitada**: Rango máximo para calculo de gasto.
  - Optimización en la obtención de datos de gastos para su análisis.
  - Eliminación del anuncio en pantalla completa al entrar en configuraciones
---
### Versión 0.1.0
  - Lanzamiento de app
