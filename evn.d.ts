/// <reference types="vite/client" />

interface ImportMetaEnv {
    readonly VITE_API_URL: string;
    readonly VITE_DEBUG: boolean;
    // ... khai báo các biến khác nếu cần
  }
  
  interface ImportMeta {
    readonly env: ImportMetaEnv;
  }
  