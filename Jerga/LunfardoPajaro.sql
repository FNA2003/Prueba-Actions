CREATE TABLE Nombre_Local_Pajaro (
    fk_pajaro INT NOT NULL REFERENCES Pajaro(id),
    nombre_local TEXT NOT NULL
);