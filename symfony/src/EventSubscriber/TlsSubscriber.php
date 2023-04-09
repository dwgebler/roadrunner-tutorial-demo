<?php

namespace App\EventSubscriber;

use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpKernel\Event\RequestEvent;
use Symfony\Component\HttpKernel\KernelEvents;

class TlsSubscriber implements EventSubscriberInterface
{
    public static function getSubscribedEvents(): array
    {
        return [
            KernelEvents::REQUEST => ['onKernelRequest', 10],
        ];
    }

    public function onKernelRequest(RequestEvent $event): void
    {
        $request = $event->getRequest();
        $certificateSubject = $request->attributes->get('certificate_subject', '');
        $cn = preg_match('/CN=([^,]+)/', $certificateSubject, $matches) ? $matches[1] : null;
        $request->server->set('SSL_CLIENT_S_DN_Email', $cn);
    }
}
