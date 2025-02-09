![Captura de pantalla (142)](https://github.com/user-attachments/assets/1ed532ea-8c10-4999-8cd3-aa2b70c6eb9d)# ![](https://user-images.githubusercontent.com/1838420/82833707-bec46580-9eb6-11ea-88d8-2dd033cc742d.png) POKE-API ![](https://user-images.githubusercontent.com/1838420/82833707-bec46580-9eb6-11ea-88d8-2dd033cc742d.png)
Esta Api consume la API de Pokemon [Poke-Api](https://pokeapi.co/)
<br>
Presione para ir a la [URL de Render](https://tp-api-pokemon.onrender.com)

    - El dispositivo utilizado fue Google Chrome
    - Esta aplicación es el resultado del Trabajo Final y hace uso de los proyectos previos Proyecto 1 y Proyecto 2.

    ## Descripcion
      La app interactúa con la Poke-API para mostrar diferentes Pokémon, sus movimientos y habilidades, ofreciendo una experiencia de combate entre Pokémon. El flujo del combate se basa        en seleccionar un Pokémon y sus movimientos, para luego enfrentar a otro Pokémon que sea débil frente a ese tipo de movimiento.
    
    ## Archivos Modificados   
      Los archivos modificados en este proyecto incluyen:

    - pokemon_move.dart: Gestión de los movimientos de los Pokémon.
    - habilidades_pokemon.dart: Llamada a la API del Proyecto 1 para obtener habilidades de los Pokémon.
    - moves_provider.dart: Gestión de los movimientos disponibles.
    - movimientos_combate_screen.dart: Pantalla de combate, donde se muestran los movimientos seleccionados y los Pokémon enfrentados.
      
    ## Caracteristicas
      En el menú de Movimientos de Combate, se presenta una pantalla con un carrusel de diferentes tipos de Pokémon. Al seleccionar uno de estos tipos, se realiza una llamada a la API          para obtener los movimientos disponibles para ese tipo. Estos movimientos se presentan en tarjetas, y al seleccionar un movimiento, se inicia un combate que enfrenta a:
      ![image](https://github.com/user-attachments/assets/3d3078cb-08ae-4225-8472-e8bff08fcb66)

      Un Pokémon que puede aprender ese movimiento.
      ![image](https://github.com/user-attachments/assets/c5d4cd47-dee9-4c6b-9808-b1fb5ec667f6)

      Un Pokémon que es débil frente al tipo de movimiento seleccionado.
      ![image](https://github.com/user-attachments/assets/c5ceb3b0-edfc-4100-a23b-0f7e5ee6b21c)
