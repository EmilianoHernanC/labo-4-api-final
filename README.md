# ![](https://user-images.githubusercontent.com/1838420/82833707-bec46580-9eb6-11ea-88d8-2dd033cc742d.png) POKE-API ![](https://user-images.githubusercontent.com/1838420/82833707-bec46580-9eb6-11ea-88d8-2dd033cc742d.png)
Esta Api consume la API de Pokemon [Poke-Api](https://pokeapi.co/)
<br>
Presione para ir a la [URL de Render](https://tp-api-pokemon.onrender.com)

 - El dispositivo utilizado fue Google Chrome
 - Esta aplicacion es el resultado del Trabajo Final y hace uso de los proyectos previos, TP-1 y TP-2

## Descripcion
  La app interactua con la Poke-API para mostrar diferentes pokemon, sus movimientos y habilidades, ofrece una experiencia de combate entre Pokemon.
El flujo del combate se basa en seleccionar un Pokemon y sus movimientos para luego enfrentarse a otro Pokemon que sea debil a ese tipo de movimiento

## Archivos Modificados
  Los archivos modificados son:
  - pokemon_move.dart: Gestion de los movimientos de los pokemon
  - habilidades_pokemon.dart: Llamada a la API del proyecto 1 para obtener las habilidades, tambien se llama a la API de pokemon para obtener los sprites y nombres de los pokemon.
  - moves_provider.dart:Gestion de los movimientos disponibles
  - movimientos_combate_screen.dart:Pantalla de combate, se muestran los tipos, las cartas de los movimientos y el enfrentamiento


  ## Caracteristicas
  En el Menu de movimientos de Combate, se presenta una pantalla con un carrusel de diferentes tipos de Pokemon. Al seleccionar uno de estos tipos, se realiza un llamado a la API para obtener los movimientos disponibles para ese tipo. Estos movimientos se presentan en tarjetas y al seleccion un movimiento se inicia un combate que enfrenta a:
  ![image](https://github.com/user-attachments/assets/fdf0f197-78b2-4c8d-ac1c-fa3facdcb783)


  Un pokemon que puede aprender ese movimiento:
  ![image](https://github.com/user-attachments/assets/c5d4cd47-dee9-4c6b-9808-b1fb5ec667f6)

VS

Uno que es debil frente al tipo de movimiento
 ![image](https://github.com/user-attachments/assets/c5ceb3b0-edfc-4100-a23b-0f7e5ee6b21c)

   ## NOTA
   -Tuve un Problema de no poder modificar de la api del proyecto 1 para que traiga mas movimientos, entonces en algunos tipos se queda corto o no trae nada directamente
   -A veces Tarda en acomodarse los pokemones cuando estan en el campo de batalla, pero si cambias los tipos y presionas en otras tarjetas se terminan de alinear correctamente.
