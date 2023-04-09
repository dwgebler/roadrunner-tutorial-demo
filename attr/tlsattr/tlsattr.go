package tlsattr

import (
	"encoding/json"
	"net/http"

	"github.com/roadrunner-server/http/v4/attributes"
	"go.uber.org/zap"
)

const PluginName = "tls-attributes"

type Plugin struct{}

func (p *Plugin) Init() error {
	return nil
}

func (p *Plugin) Middleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		r = attributes.Init(r)
		attributes.Set(r, "HTTPS", false)
		if r.TLS != nil {
			attributes.Set(r, "HTTPS", true)
			if len(r.TLS.PeerCertificates) > 0 {
                cert, err := json.Marshal(r.TLS.PeerCertificates[0])
                if err != nil {
                    zap.L().Error("failed to marshal certificate", zap.Error(err))
                } else {
                    attributes.Set(r, "certificate", string(cert))
                    attributes.Set(r, "certificate_subject", r.TLS.PeerCertificates[0].Subject.String())
                }
			}
		}
		next.ServeHTTP(w, r)
	})
}

// Middleware/plugin name.
func (p *Plugin) Name() string {
	return PluginName
}