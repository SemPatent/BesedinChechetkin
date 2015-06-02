--1) Прямое сравнение разниц координат вектора с допустимой ошибкой delta
CREATE OR REPLACE  FUNCTION compare_vector (val_vector double precision[], val_index INTEGER[], delta double precision)
RETURNS INTEGER[] AS
$BODY$
DECLARE

  colname text;
  valueVectorIn double precision;
  valueVectorCur double precision;
  i integer;
  j integer;
  indexCompare integer;
  result INTEGER[];
  id_doc BIGINT;
  val_vector_cur double precision[];
  isEqual integer;
BEGIN


  j := 1;
  
  FOR id_doc IN SELECT values_​​of_the_vectors.id_document FROM values_​​of_the_vectors LOOP -- проход по все таблице
    isEqual := 1;
colname := 'c1';
    FOR i IN 1..array_upper(val_index, 1) LOOP
     
     indexCompare := val_index[i];
     valueVectorIn := val_vector[indexCompare];
     EXECUTE 'SELECT '|| quote_ident(colname) || ' FROM values_​​of_the_vectors where id_document=id_doc' INTO valueVectorCur;
     colname:=REPLACE(colname, CAST(i AS CHAR(1)), CAST((i+1) AS CHAR(1)));
      
     IF abs(valueVectorIn - valueVectorCur) > delta THEN
  isEqual = 0;
     END IF;

    END LOOP;
    IF isEqual = 1 THEN
  result[j] := id_document;
  j := j+1;
    END IF;
  END LOOP;
  
  RETURN result; 
END
$BODY$
LANGUAGE plpgsql;