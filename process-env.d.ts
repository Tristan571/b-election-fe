import dotenv from 'dotenv';
dotenv.config();

declare global {
    namespace NodeJS {
      interface ProcessEnv {
        [key: string]: string | undefined;
        DB_CONN_STRING: string,
        DB_NAME: string,
        VOTING_COLLECTION_NAME: string,
        REACT_APP_API_URL:string,
      }
    }
  }