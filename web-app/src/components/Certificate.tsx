import { useEffect, useState } from 'react';
import { useNavigate } from '@tanstack/react-router';
import { useMember, useCalculation, getSavedMemberCode, clearMemberCode } from '../hooks/useMember';
import { t, formatCurrency, formatPercentage, formatMonth } from '../utils/i18n';
import type { Member } from '../types';

export function Certificate() {
  const [memberCode, setMemberCode] = useState<string | null>(null);
  const navigate = useNavigate();

  useEffect(() => {
    const savedCode = getSavedMemberCode();
    if (!savedCode) {
      navigate({ to: '/' });
    } else {
      setMemberCode(savedCode);
    }
  }, [navigate]);

  const { data: member, isLoading: memberLoading, error: memberError } = useMember(memberCode);
  const { data: calculation, isLoading: calcLoading, refetch } = useCalculation(member, !!member);

  const isLoading = memberLoading || calcLoading;
  const language = (member as Member)?.language || 'en';

  const handleChangeCode = () => {
    clearMemberCode();
    navigate({ to: '/' });
  };

  const handleRefresh = () => {
    refetch();
  };

  if (memberError) {
    return (
      <div className="min-h-screen flex items-center justify-center p-4">
        <div className="text-center">
          <p className="text-red-500 mb-4">{t('code.error.network', language)}</p>
          <button onClick={handleChangeCode} className="btn-secondary">
            {t('certificate.changeCode', language)}
          </button>
        </div>
      </div>
    );
  }

  if (!member && !isLoading) {
    return null;
  }

  return (
    <div className="min-h-screen p-4 bg-gradient-to-br from-slate-100 to-slate-200">
      <div className="max-w-lg mx-auto pt-8 animate-fade-in">
        {/* Header */}
        <div className="text-center mb-8">
          <div className="w-16 h-16 mx-auto mb-4 gradient-bg rounded-xl flex items-center justify-center shadow-md">
            <span className="text-white text-2xl font-bold">YS</span>
          </div>
          {member && (
            <h1 className="text-2xl font-bold text-gray-800">
              {t('certificate.greeting', language)}, {member.name}!
            </h1>
          )}
          <p className="text-gray-500 mt-1">{t('certificate.title', language)}</p>
        </div>

        {/* Certificate Card */}
        <div className="card card-gradient-border mb-6 animate-slide-up">
          {isLoading ? (
            <div className="py-12 flex flex-col items-center justify-center">
              <svg
                className="animate-spin h-10 w-10 text-primary-teal mb-4"
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
              <p className="text-gray-500">{t('certificate.loading', language)}</p>
            </div>
          ) : calculation ? (
            <div className="space-y-6">
              {/* Current Value */}
              <div className="text-center">
                <p className="text-sm text-gray-500 uppercase tracking-wide mb-2">
                  {t('certificate.currentValue', language)}
                </p>
                <div className="animate-value">
                  <span className="text-4xl md:text-5xl font-bold gradient-text">
                    {formatCurrency(calculation.currentValue, language)}
                  </span>
                </div>
              </div>

              {/* Divider */}
              <div className="h-px bg-gradient-to-r from-transparent via-gray-200 to-transparent" />

              {/* Percentage Gain */}
              <div className="flex items-center justify-center gap-2">
                <div className={`flex items-center gap-1 ${calculation.percentageGain >= 0 ? 'text-green-500' : 'text-red-500'}`}>
                  {calculation.percentageGain >= 0 ? (
                    <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M5.293 9.707a1 1 0 010-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 01-1.414 1.414L11 7.414V15a1 1 0 11-2 0V7.414L6.707 9.707a1 1 0 01-1.414 0z" clipRule="evenodd" />
                    </svg>
                  ) : (
                    <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M14.707 10.293a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 111.414-1.414L9 12.586V5a1 1 0 012 0v7.586l2.293-2.293a1 1 0 011.414 0z" clipRule="evenodd" />
                    </svg>
                  )}
                  <span className="text-xl font-semibold">
                    {formatPercentage(calculation.percentageGain)}
                  </span>
                </div>
                <span className="text-gray-400 text-sm">
                  {t('certificate.gain', language)}
                </span>
              </div>

              {/* Last Updated */}
              {calculation.lastUpdatedMonth && (
                <div className="text-center text-sm text-gray-400">
                  {t('certificate.lastUpdated', language)}: {formatMonth(calculation.lastUpdatedMonth, language)}
                </div>
              )}
            </div>
          ) : member && member.shares === 0 ? (
            <div className="py-12 text-center text-gray-500">
              {t('certificate.noValue', language)}
            </div>
          ) : null}
        </div>

        {/* Action Buttons */}
        <div className="flex gap-3">
          <button
            onClick={handleRefresh}
            disabled={isLoading}
            className="btn-primary flex-1 flex items-center justify-center gap-2"
          >
            {isLoading ? (
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
            ) : (
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
              </svg>
            )}
            {t('certificate.refresh', language)}
          </button>
          <button
            onClick={handleChangeCode}
            className="btn-secondary"
          >
            {t('certificate.changeCode', language)}
          </button>
        </div>

        {/* Footer */}
        <p className="text-center text-gray-400 text-xs mt-8">
          YourShare Investment Tracker
        </p>
      </div>
    </div>
  );
}
