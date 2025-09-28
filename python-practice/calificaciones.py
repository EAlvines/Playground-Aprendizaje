def calculo_promedio():
    calificaciones = [] #lista donde se va almacenar
    
    while True:
        try:
            calificacion = float(input("Ingrese la nota (Ingrese un negativo para finalizar)"))

            if calificacion < 0:
                break

            calificaciones.append(calificacion)
        except ValueError:
            print("Por favor, ingresar un numero valido")

    if len(calificaciones) > 0:
        promedio = sum(calificaciones)/len(calificaciones)
        print(f"Promedio de las calificaciones: {promedio:.2f}")

        if promedio >= 60:
            print("El promedio es aprobatorio")
        else:
            print("No se ingresaron calificaciones válidas")
        
calculo_promedio()

