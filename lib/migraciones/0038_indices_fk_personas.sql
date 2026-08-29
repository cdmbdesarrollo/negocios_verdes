-- 0038_indices_fk_personas.sql
--
-- `negocio_representante` ya tenía índice en la FK del lado persona
-- (`negocio_representante_persona_idx`, 0029) pero `negocio_delegado` y
-- `negocio_responsable` no — el advisor de rendimiento lo marcaba
-- (`unindexed_foreign_keys`). Las vistas `v_delegados` / `v_responsables`
-- hacen `count(*) ... where delegado_id = p.id` por cada persona, así que
-- este índice les evita el seq-scan.
--
-- Idempotente.

create index if not exists negocio_delegado_persona_idx
  on negocio_delegado (delegado_id);

create index if not exists negocio_responsable_persona_idx
  on negocio_responsable (responsable_id);
