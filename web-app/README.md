# YourShare Web App

A web-based investment certificate viewer built with TanStack (Router + Query), React, and Bun.

## Features

- Code-based authentication system
- Real-time investment value display
- Multi-language support (English & Hungarian)
- Responsive design for mobile and desktop
- GBP currency formatting
- Percentage gain visualization

## Tech Stack

- **Runtime**: Bun
- **Framework**: React 18
- **Routing**: TanStack Router
- **Data Fetching**: TanStack Query
- **Styling**: Tailwind CSS
- **Build Tool**: Vite
- **Backend**: Supabase

## Development

```bash
# Install dependencies
bun install

# Start development server
bun run dev

# Build for production
bun run build

# Preview production build
bun run preview
```

## Deployment to Railway

1. Connect your GitHub repository to Railway
2. Railway will automatically detect the Dockerfile
3. Deploy!

Or use the Railway CLI:

```bash
railway up
```

## Environment Variables

No environment variables needed - the app connects directly to the Supabase backend.

## Member Codes

Use these test member codes:
- `ANYU-2024` (Hungarian)
- `DEL-STAR` (English)
- `MUM-GOLD` (English)
- `DOM-HERO` (English)
