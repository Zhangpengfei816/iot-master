import {CanMatchFn, Router} from '@angular/router';
import {inject} from "@angular/core";
import {UserService} from "./user.service";
import {Subject} from "rxjs";

export const authGuard: CanMatchFn = (route, segments) => {
    const us = inject(UserService);
    const router = inject(Router);

    if (us.user) {
        return true;
    }

    if (us.getting) {
        const sub = new Subject<any>();
        us.userSub.subscribe({
            next: res => {
                if (res) {
                    sub.next(true);
                } else {
                    sub.next(router.parseUrl("/login"));
                }
                sub.complete();
            }
        });
        return sub.asObservable();
    }

    return router.parseUrl("/login")
};
