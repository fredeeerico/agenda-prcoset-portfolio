INSERT INTO public.eventos (
  agenda_presidente,
  titulo,
  data,
  hora_inicio,
  hora_fim,
  local,
  endereco,
  cobertura,
  responsaveis,
  equipamentos,
  observacoes,
  precisa_motorista,
  motorista_nome,
  motorista_telefone,
  status
)
SELECT
  (random() * 2 + 1)::int AS agenda_presidente,

  CASE tipo_evento
    WHEN 1 THEN 'Monitoramento contínuo da infraestrutura'
    WHEN 2 THEN 'Reunião técnica de planejamento'
    ELSE 'Vistoria técnica em obra'
  END AS titulo,

  data_evento AS data,

  CASE tipo_evento
    WHEN 1 THEN TIME '00:00'          -- evento do dia todo
    WHEN 2 THEN TIME '08:00' + (random() * INTERVAL '4 hours')  -- manhã
    ELSE TIME '13:00' + (random() * INTERVAL '4 hours')          -- tarde
  END AS hora_inicio,

  CASE tipo_evento
    WHEN 1 THEN TIME '23:59'
    WHEN 2 THEN (TIME '08:00' + (random() * INTERVAL '4 hours')) + (random() * INTERVAL '4 hours')
    ELSE (TIME '13:00' + (random() * INTERVAL '4 hours')) + (random() * INTERVAL '4 hours')
  END AS hora_fim,

  CASE tipo_evento
    WHEN 1 THEN 'Centro de Operações de Infraestrutura'
    WHEN 2 THEN 'Sede da Secretaria de Infraestrutura'
    ELSE 'Frente de obra'
  END AS local,

  CASE tipo_evento
    WHEN 3 THEN 'Rodovia Estadual KM ' || (random() * 400)::int
    ELSE 'Av. Governamental, ' || (random() * 800)::int
  END AS endereco,

  CASE
    WHEN random() < 0.45 THEN 'Comunicação Institucional'
    ELSE 'Sem cobertura'
  END AS cobertura,

  -- Responsáveis fixos
  CASE tipo_evento
    WHEN 1 THEN 'Fred, Ana'
    WHEN 2 THEN 'Silvano'
    ELSE 'Thais, Fred'
  END AS responsaveis,

  CASE tipo_evento
    WHEN 1 THEN 'Monitoramento remoto, Sistemas internos'
    WHEN 2 THEN 'Notebook, Projetor, Documentação técnica'
    ELSE 'Capacete, Colete refletivo, Veículo oficial'
  END AS equipamentos,

  CASE tipo_evento
    WHEN 1 THEN 'Acompanhamento ininterrupto das operações da infraestrutura.'
    WHEN 2 THEN 'Discussão técnica para alinhamento e tomada de decisão.'
    ELSE 'Fiscalização presencial do andamento físico da obra.'
  END AS observacoes,

  CASE
    WHEN tipo_evento = 3 THEN 1
    ELSE 0
  END AS precisa_motorista,

  CASE
    WHEN tipo_evento = 3 THEN 'Carlos Motorista'
    ELSE NULL
  END AS motorista_nome,

  -- Número de telefone fictício no formato 55XXXXXXXXXXX
  CASE
    WHEN tipo_evento = 3 THEN
      '55' || LPAD((trunc(random() * 100000000000)::bigint)::text, 11, '0')
    ELSE NULL
  END AS motorista_telefone,

  CASE
    WHEN random() < 0.15 THEN 'cancelado'
    WHEN random() < 0.35 THEN 'pendente'
    WHEN random() < 0.70 THEN 'confirmado'
    ELSE 'concluido'
  END AS status

FROM (
  SELECT
    d::date AS data_evento,
    gs AS tipo_evento
  FROM generate_series(
    DATE '2026-01-01',
    DATE '2026-12-31',
    INTERVAL '1 day'
  ) d
  CROSS JOIN generate_series(1, 3) gs
) base;
