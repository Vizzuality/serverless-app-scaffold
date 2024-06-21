import express, {Request, Response, Router} from 'express';
import 'reflect-metadata';
import * as crypto from "crypto";

//We're using express to simplify path parameter parsing, it might be not be needed in your case
const router = Router();
const app = express();
app.use('/', router);
exports.functionApp = app;


router.get('/', async (req: Request, res: Response) : Promise<void> => {
  const logId = crypto.createHash('sha1').update(performance.now().toString()).digest('hex');

  ///// This block handles CORS
  res.set('Access-Control-Allow-Origin', '*');
  if (req.method === 'OPTIONS') {
    // Send response to OPTIONS requests
    res.set('Access-Control-Allow-Methods', 'GET, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type');
    res.set('Access-Control-Max-Age', '3600');
    res.status(204).send('');
    return;
  }

  console.log(`${logId} - Got a greetings request`)

  try{
    res.status(200).send('Hello Scaffold')
  }catch(error){
    res.status( 500 ).json( { errors: [error] } )
  }
});
