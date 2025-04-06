select
  GL.FiscalYear,
  GL.CCcode || GL.Dcode as CDScode,
  GL.Fund as Fund,
  GL.Object as Object,
  OBJ.Description as Object_Description,
  GL.Goal as Goal,
  GOAL.Description as Goal_Description,
  sum(Value) as Total
from Ledger as GL
  join Object as OBJ on OBJ.FiscalYear = GL.FiscalYear and OBJ.Object = GL.Object
  join Goal as GOAL on GOAL.Goal = GL.Goal
group by all
order by GL.FiscalYear, CDScode, Fund, Object, Goal