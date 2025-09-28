import tkinter as tk

def click_boton(valor):
    entrada.insert(tk.END, valor)

def borrar():
    entrada.delete(0, tk.END)

def calcular():
    try:
        resultado = eval(entrada.get())
        entrada.delete(0, tk.END)
        entrada.insert(tk.END, resultado)
    except:
        entrada.delete(0, tk.END)
        entrada.insert(tk.END, "Error")

ventana = tk.Tk()
ventana.title("CALCULADORA")
ventana.geometry("300x400")
ventana.resizable(True, True)


entrada = tk.Entry(ventana, font=("Arial", 20), borderwidth=5, relief=tk.RIDGE, justify="right")
entrada.pack(fill=tk.BOTH, padx=10, pady=10, ipady=10, ipadx=10)

frame_botones = tk.Frame(ventana)
frame_botones.pack(expand=True, fill='none')

botones = [
    ("7", 1, 0), ("8", 1, 1), ("9", 1, 2), ("/", 1, 3),
    ("4", 2, 0), ("5", 2, 1), ("6", 2, 2), ("*", 2, 3),
    ("1", 3, 0), ("2", 3, 1), ("3", 3, 2), ("-", 3, 3),
    ("0", 4, 0), (".", 4, 1), ("=", 4, 2), ("+", 4, 3),
]

for (texto, fila, columna) in botones:
    if texto == "=":
        boton = tk.Button(frame_botones, text=texto, width=3, height=1, font=("Arial", 18), command=calcular, bg="#FF00FF", fg="white")

    else:
        boton = tk.Button(frame_botones, text=texto, width=3, height=1, font=("Arial", 18), command=lambda t=texto: click_boton(t))

    boton.grid(row=fila, column=columna, padx=5, pady=5)

boton_borrar = tk.Button(ventana, text="Borrar", width=20, height=2, font=("Arial", 14), 
                         command=borrar, bg="#FF00FF", fg="white")

boton_borrar.pack(pady=10)

ventana.mainloop()
