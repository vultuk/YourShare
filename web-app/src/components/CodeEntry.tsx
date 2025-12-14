import { useState } from 'react';
import { useNavigate } from '@tanstack/react-router';
import { fetchMemberByCode } from '../services/supabase';
import { saveMemberCode } from '../hooks/useMember';
import { t } from '../utils/i18n';

export function CodeEntry() {
  const [code, setCode] = useState('');
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!code.trim()) return;

    setIsLoading(true);
    setError('');

    try {
      const member = await fetchMemberByCode(code.trim());

      if (member) {
        saveMemberCode(code.trim());
        navigate({ to: '/certificate' });
      } else {
        setError(t('code.error.invalid'));
      }
    } catch {
      setError(t('code.error.network'));
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center p-4 bg-gradient-to-br from-slate-100 to-slate-200">
      <div className="w-full max-w-md animate-fade-in">
        {/* Logo */}
        <div className="text-center mb-8">
          <div className="w-20 h-20 mx-auto mb-4 gradient-bg rounded-2xl flex items-center justify-center shadow-lg">
            <span className="text-white text-3xl font-bold">YS</span>
          </div>
          <h1 className="text-3xl font-bold gradient-text">{t('app.title')}</h1>
          <p className="text-gray-500 mt-2">{t('app.tagline')}</p>
        </div>

        {/* Card */}
        <div className="card card-gradient-border animate-slide-up">
          <form onSubmit={handleSubmit} className="space-y-6">
            <div>
              <input
                type="text"
                value={code}
                onChange={(e) => setCode(e.target.value.toUpperCase())}
                placeholder={t('code.placeholder')}
                className="input-field text-center text-lg font-mono tracking-wider"
                disabled={isLoading}
                autoFocus
              />
            </div>

            {error && (
              <div className="text-red-500 text-sm text-center animate-fade-in">
                {error}
              </div>
            )}

            <button
              type="submit"
              disabled={!code.trim() || isLoading}
              className="btn-primary w-full flex items-center justify-center gap-2"
            >
              {isLoading ? (
                <>
                  <svg
                    className="animate-spin h-5 w-5"
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none"
                    viewBox="0 0 24 24"
                  >
                    <circle
                      className="opacity-25"
                      cx="12"
                      cy="12"
                      r="10"
                      stroke="currentColor"
                      strokeWidth="4"
                    />
                    <path
                      className="opacity-75"
                      fill="currentColor"
                      d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                    />
                  </svg>
                  {t('certificate.loading')}
                </>
              ) : (
                t('code.submit')
              )}
            </button>
          </form>
        </div>

        {/* Footer */}
        <p className="text-center text-gray-400 text-sm mt-8">
          Secure investment tracking
        </p>
      </div>
    </div>
  );
}
