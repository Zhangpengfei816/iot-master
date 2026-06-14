import {Injectable} from '@angular/core';
import {Subject} from "rxjs";
import {HttpClient} from "@angular/common/http";
import {SmartRequestService} from "@god-jason/smart";

@Injectable({
    providedIn: 'root'
})
export class UserService {

    public user: any;
    public userSub = new Subject<any>();

    public getting = true;

    constructor(private rs: SmartRequestService, private http: HttpClient) {
        http.get('/api/me', {withCredentials: true}).subscribe({
            next: (res: any) => {
                if (res && res.data) {
                    this.setUser(res.data);
                    this.userSub.next(res.data);
                } else {
                    this.userSub.next(null);
                }
            }, error: err => {
                this.userSub.next(null);
            }
        }).add(() => {
            this.getting = false;
        })
    }

    setUser(user: any) {
        this.user = user;
    }

    getUser() {
        return this.user;
    }

    subscribe() {
        return this.userSub.subscribe()
    }

}
