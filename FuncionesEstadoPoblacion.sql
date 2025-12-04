-- Funcion auxiliar para el trigger de abajo
CREATE OR REPLACE FUNCTION calcular_estado_poblacion(
  old_poblacion BIGINT,
  new_poblacion BIGINT
) RETURNS TEXT AS $$
DECLARE
  resultado TEXT;
BEGIN
  IF old_poblacion > new_poblacion THEN
    resultado := 'Disminución poblacional';
  ELSIF old_poblacion < new_poblacion THEN
    resultado := 'Crecimiento poblacional';
  ELSE
    resultado := 'Estabilidad poblacional';
  END IF;
  RETURN resultado;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION tg_peligro()
RETURNS TRIGGER AS $$
DECLARE
  aux_estado TEXT;
BEGIN
  aux_estado := calcular_estado_poblacion(OLD.poblacion, NEW.poblacion);

  IF NOT EXISTS (SELECT 1 FROM Estado_Especie_Ave WHERE fk_ave = OLD.fk_ave) THEN
    INSERT INTO Estado_Especie_Ave (fk_ave, estado_poblacion)
    VALUES (OLD.fk_ave, aux_estado);
  ELSE
    UPDATE Estado_Especie_Ave
    SET estado_poblacion = aux_estado
    WHERE fk_ave = OLD.fk_ave;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER preservacion_natural
AFTER UPDATE ON Aves_Vistas
FOR EACH ROW
EXECUTE FUNCTION tg_peligro();
