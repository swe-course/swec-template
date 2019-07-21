import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders, HttpResponse, HttpParams, HttpErrorResponse } from '@angular/common/http';
import { Observable } from 'rxjs';
import { ErrorObservable } from 'rxjs/observable/ErrorObservable';
import { catchError, map, retry } from 'rxjs/operators';
import { of } from 'rxjs';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

  requestType = 'GET';
  requestUrl = 'http://46.101.7.84:9081/stats'; // 'http://localhost:9080';
  withCredentials = true;
  requestBody = '{}';
  response = '';
  success = false;

  constructor(private http: HttpClient) { }

  ngOnInit() {
  }

  onSend() {
    this.response = '';
    const options = {
//      headers:new HttpHeaders ({
//        "Content-Type": "application/json"
//      }),
      withCredentials: this.withCredentials
    };
    console.log(this.requestUrl);
    this.http.get<string>(this.requestUrl, options)
      .pipe(
        map(res => {
          console.log(res);
          return res;
        }),
        catchError(this.handleError<string>('Send', undefined))
      ).subscribe(
      (v) => {
        this.success = true;
        this.response = JSON.stringify(v);
      },
      (err) => {
        this.success = false;
        // console.log(err);
        this.response = err;
      },
      () => {
      }
    );
  }

  private handleError<T>(operation = 'operation', result?: T) {
    return (error: HttpErrorResponse): Observable<T> => {
      console.error(error); // log to console instead
      // console.error(result); // log to console instead
      throw new Error(`${operation} failed [${error.message}]`); // use this for subscribe(error:) to fire
      // Let the app keep running by returning an empty result.
      // return of(result as T);
    };
  }

}
