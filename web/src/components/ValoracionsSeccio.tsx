import React, { useState, useEffect, useCallback } from 'react';

const LIMIT = 5;

// ── Types ─────────────────────────────────────────────────────────────────────

interface Autor {
  id: string;
  nomUsuari: string;
  fotoPerfil: string | null;
}

interface Valoracio {
  id: string;
  puntuacio: number;
  comentari: string;
  dataValoracio: string;
  autor: Autor;
  esMeva: boolean;
}

interface Meta {
  total: number;
  page: number;
  lastPage: number;
  hasMore: boolean;
}

interface ValoracionResponse {
  mitjana: number;
  total: number;
  valoracions: Valoracio[];
  meta: Meta;
}

interface Props {
  readonly activitatId: string;
  readonly usuariId?: string;
}

// ── Helpers ───────────────────────────────────────────────────────────────────

const formatDate = (iso: string) =>
  new Intl.DateTimeFormat('ca', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
  }).format(new Date(iso));

// ── Sub-components ────────────────────────────────────────────────────────────

function Stars({ value, large = false }: { readonly value: number; readonly large?: boolean }) {
  return (
    <span className={large ? 'text-xl' : 'text-sm'}>
      {Array.from({ length: 5 }, (_, i) => (
        <span key={i} style={{ color: i < value ? '#f59e0b' : '#d1d5db' }}>
          ★
        </span>
      ))}
    </span>
  );
}

function Avatar({ autor }: { readonly autor: Autor }) {
  if (autor.fotoPerfil) {
    return (
      <img
        src={autor.fotoPerfil}
        alt={autor.nomUsuari}
        style={styles.avatar}
      />
    );
  }
  return (
    <div style={{ ...styles.avatar, ...styles.avatarFallback }}>
      {autor.nomUsuari[0].toUpperCase()}
    </div>
  );
}

function SkeletonCard() {
  return (
    <div style={styles.skeletonCard}>
      <div style={{ ...styles.skeletonCircle, ...styles.pulse }} />
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 8 }}>
        <div style={{ ...styles.skeletonLine, width: 100, ...styles.pulse }} />
        <div style={{ ...styles.skeletonLine, width: '100%', ...styles.pulse }} />
        <div style={{ ...styles.skeletonLine, width: '75%', ...styles.pulse }} />
      </div>
    </div>
  );
}

function ResenyaCard({ valoracio }: { readonly valoracio: Valoracio }) {
  return (
    <div
      style={{
        ...styles.card,
        ...(valoracio.esMeva ? styles.cardPropiaRessenya : {}),
      }}
    >
      <Avatar autor={valoracio.autor} />
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={styles.cardHeader}>
          <span style={styles.nomUsuari}>
            {valoracio.autor.nomUsuari}
            {valoracio.esMeva && (
              <span style={styles.badgeMeva}> (la teva)</span>
            )}
          </span>
          <span style={styles.dataText}>
            {formatDate(valoracio.dataValoracio)}
          </span>
        </div>
        <Stars value={valoracio.puntuacio} />
        {valoracio.comentari && (
          <p style={styles.comentari}>{valoracio.comentari}</p>
        )}
      </div>
    </div>
  );
}

// ── Main component ────────────────────────────────────────────────────────────

export default function ValoracionsSeccio({ activitatId, usuariId }: Props) {
  const [valoracions, setValorations] = useState<Valoracio[]>([]);
  const [mitjana, setMitjana] = useState(0);
  const [totalGlobal, setTotalGlobal] = useState(0);
  const [meta, setMeta] = useState<Meta | null>(null);
  const [page, setPage] = useState(1);
  const [loading, setLoading] = useState(true);
  const [loadingMore, setLoadingMore] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchPage = useCallback(
    async (pageNum: number, append: boolean) => {
      append ? setLoadingMore(true) : setLoading(true);
      setError(null);

      try {
        const headers: HeadersInit = {};
        if (usuariId) headers['usuari-id'] = usuariId;

        const res = await fetch(
          `/api/activitats/${activitatId}/valoracions?page=${pageNum}&limit=${LIMIT}`,
          { headers }
        );
        if (!res.ok) throw new Error('Error en la resposta del servidor');

        const data: ValoracionResponse = await res.json();

        if (!append) {
          setMitjana(data.mitjana);
          setTotalGlobal(data.total);
        }
        setValorations((prev) =>
          append ? [...prev, ...data.valoracions] : data.valoracions
        );
        setMeta(data.meta);
      } catch {
        setError("No s'han pogut carregar les valoracions.");
      } finally {
        setLoading(false);
        setLoadingMore(false);
      }
    },
    [activitatId, usuariId]
  );

  useEffect(() => {
    fetchPage(1, false);
  }, [fetchPage]);

  const handleCarregarMes = () => {
    const next = page + 1;
    setPage(next);
    fetchPage(next, true);
  };

  // ── Render ────────────────────────────────────────────────────────────────

  if (loading) {
    return (
      <section style={styles.section}>
        <div style={{ ...styles.skeletonLine, width: 160, height: 20, marginBottom: 16, ...styles.pulse }} />
        <SkeletonCard />
        <SkeletonCard />
        <SkeletonCard />
      </section>
    );
  }

  if (error) {
    return <p style={styles.errorText}>{error}</p>;
  }

  if (valoracions.length === 0) {
    return (
      <div style={styles.emptyState}>
        Encara no hi ha ressenyes per a aquesta activitat
      </div>
    );
  }

  return (
    <section style={styles.section}>
      {/* Capçalera */}
      <div style={styles.header}>
        <div style={styles.scoreBox}>
          <span style={styles.scoreNumber}>{mitjana.toFixed(1)}</span>
          <Stars value={Math.round(mitjana)} />
        </div>
        <div>
          <p style={styles.totalText}>
            {totalGlobal} valoració{totalGlobal === 1 ? '' : 'ns'}
          </p>
          <p style={styles.subtitleText}>Puntuació mitjana</p>
        </div>
      </div>

      {/* Llistat */}
      <div style={styles.list}>
        {valoracions.map((v) => (
          <ResenyaCard key={v.id} valoracio={v} />
        ))}
      </div>

      {/* Carregar més */}
      {meta?.hasMore && (
            <button
              onClick={handleCarregarMes}
              disabled={loadingMore}
              style={{
                ...styles.loadMoreBtn,
                ...(loadingMore ? styles.loadMoreBtnDisabled : {}),
              }}
            >
              {loadingMore ? (
                <span style={styles.loadingRow}>
                  <span style={styles.spinner} />
                  <span>Carregant...</span>
                </span>
              ) : (
                'Carregar més'
              )}
            </button>
      )}
    </section>
  );
}

// ── Styles ────────────────────────────────────────────────────────────────────

const ORANGE = '#ea9b63';
const ORANGE_LIGHT = '#fdf4ec';
const ORANGE_BORDER = '#f5d4b3';

const styles: Record<string, React.CSSProperties> = {
  section: {
    display: 'flex',
    flexDirection: 'column',
    gap: 12,
  },
  header: {
    display: 'flex',
    alignItems: 'center',
    gap: 16,
    marginBottom: 4,
  },
  scoreBox: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    background: ORANGE_LIGHT,
    border: `1px solid ${ORANGE_BORDER}`,
    borderRadius: 12,
    padding: '10px 16px',
    minWidth: 72,
  },
  scoreNumber: {
    fontSize: 26,
    fontWeight: 700,
    color: ORANGE,
    lineHeight: 1.1,
  },
  totalText: {
    fontSize: 14,
    fontWeight: 600,
    color: '#1f2937',
    margin: 0,
  },
  subtitleText: {
    fontSize: 12,
    color: '#9ca3af',
    margin: 0,
    marginTop: 2,
  },
  list: {
    display: 'flex',
    flexDirection: 'column',
    gap: 8,
  },
  card: {
    display: 'flex',
    gap: 12,
    padding: 16,
    borderRadius: 12,
    background: '#fff',
    border: '1px solid #f3f4f6',
  },
  cardPropiaRessenya: {
    background: ORANGE_LIGHT,
    border: `1px solid ${ORANGE_BORDER}`,
  },
  cardHeader: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: 8,
    flexWrap: 'wrap' as const,
    marginBottom: 2,
  },
  nomUsuari: {
    fontSize: 14,
    fontWeight: 600,
    color: '#111827',
  },
  badgeMeva: {
    fontSize: 11,
    fontWeight: 500,
    color: ORANGE,
    marginLeft: 6,
  },
  dataText: {
    fontSize: 11,
    color: '#9ca3af',
    whiteSpace: 'nowrap' as const,
  },
  comentari: {
    fontSize: 13,
    color: '#4b5563',
    lineHeight: 1.5,
    margin: 0,
    marginTop: 6,
  },
  avatar: {
    width: 40,
    height: 40,
    borderRadius: '50%',
    objectFit: 'cover' as const,
    flexShrink: 0,
  },
  avatarFallback: {
    background: ORANGE,
    color: '#fff',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    fontSize: 14,
    fontWeight: 700,
  },
  emptyState: {
    textAlign: 'center' as const,
    padding: '40px 0',
    color: '#9ca3af',
    fontSize: 14,
  },
  loadMoreBtn: {
    width: '100%',
    padding: '10px 0',
    fontSize: 14,
    fontWeight: 500,
    color: ORANGE,
    background: 'transparent',
    border: `1px solid ${ORANGE_BORDER}`,
    borderRadius: 12,
    cursor: 'pointer',
    transition: 'background 0.15s',
  },
  loadMoreBtnDisabled: {
    opacity: 0.55,
    cursor: 'not-allowed',
  },
  loadingRow: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
  },
  spinner: {
    display: 'inline-block',
    width: 14,
    height: 14,
    border: `2px solid ${ORANGE_BORDER}`,
    borderTopColor: ORANGE,
    borderRadius: '50%',
    animation: 'spin 0.7s linear infinite',
  },
  errorText: {
    textAlign: 'center' as const,
    color: '#ef4444',
    fontSize: 14,
    padding: '24px 0',
  },
  skeletonCard: {
    display: 'flex',
    gap: 12,
    padding: 16,
  },
  skeletonCircle: {
    width: 40,
    height: 40,
    borderRadius: '50%',
    background: '#e5e7eb',
    flexShrink: 0,
  },
  skeletonLine: {
    height: 12,
    borderRadius: 6,
    background: '#e5e7eb',
  },
  pulse: {
    animation: 'pulse 1.5s ease-in-out infinite',
  },
};
