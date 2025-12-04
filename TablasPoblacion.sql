CREATE TABLE Aves_Vistas (
  fk_ave INT REFERENCES Pajaro(id),
  poblacion BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (fk_ave)
);

CREATE TABLE Estado_Especie_Ave (
  fk_ave INT REFERENCES Pajaro(id),
  estado_poblacion TEXT,
  PRIMARY KEY (fk_ave)
);