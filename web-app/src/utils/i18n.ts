type Language = 'en' | 'hu';

interface Translations {
  [key: string]: {
    en: string;
    hu: string;
  };
}

const translations: Translations = {
  // Code Entry Screen
  'app.title': {
    en: 'YourShare',
    hu: 'YourShare',
  },
  'app.tagline': {
    en: 'View your investment certificate',
    hu: 'Tekintsd meg befektetési igazolásod',
  },
  'code.placeholder': {
    en: 'Enter your member code',
    hu: 'Add meg a tagkódod',
  },
  'code.submit': {
    en: 'View Certificate',
    hu: 'Igazolás megtekintése',
  },
  'code.error.invalid': {
    en: 'Invalid member code. Please try again.',
    hu: 'Érvénytelen tagkód. Kérlek, próbáld újra.',
  },
  'code.error.network': {
    en: 'Network error. Please check your connection.',
    hu: 'Hálózati hiba. Kérlek, ellenőrizd a kapcsolatot.',
  },

  // Certificate Screen
  'certificate.greeting': {
    en: 'Hello',
    hu: 'Szia',
  },
  'certificate.title': {
    en: 'Your Investment Certificate',
    hu: 'Befektetési Igazolásod',
  },
  'certificate.currentValue': {
    en: 'Current Value',
    hu: 'Jelenlegi Érték',
  },
  'certificate.gain': {
    en: 'Gain Since Investment',
    hu: 'Nyereség a Befektetés Óta',
  },
  'certificate.lastUpdated': {
    en: 'Last Updated',
    hu: 'Utolsó Frissítés',
  },
  'certificate.refresh': {
    en: 'Refresh',
    hu: 'Frissítés',
  },
  'certificate.changeCode': {
    en: 'Change Code',
    hu: 'Kód Módosítása',
  },
  'certificate.loading': {
    en: 'Loading...',
    hu: 'Betöltés...',
  },
  'certificate.noValue': {
    en: 'No investment value',
    hu: 'Nincs befektetési érték',
  },
};

export function t(key: string, language: Language = 'en'): string {
  const translation = translations[key];
  if (!translation) {
    console.warn(`Missing translation for key: ${key}`);
    return key;
  }
  return translation[language] || translation.en;
}

export function formatCurrency(value: number, _language: Language = 'en'): string {
  return new Intl.NumberFormat('en-GB', {
    style: 'currency',
    currency: 'GBP',
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(value);
}

export function formatPercentage(value: number): string {
  return `${value >= 0 ? '+' : ''}${value.toFixed(2)}%`;
}

export function formatMonth(dateString: string, language: Language = 'en'): string {
  const date = new Date(dateString);
  return new Intl.DateTimeFormat(language === 'hu' ? 'hu-HU' : 'en-GB', {
    year: 'numeric',
    month: 'long',
  }).format(date);
}
