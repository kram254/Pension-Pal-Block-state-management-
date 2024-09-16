from app import db

class Pension(db.Model):
    __tablename__ = 'pensions'

    id = db.Column(db.Integer, primary_key=True)
    scheme_name = db.Column(db.String(100), nullable=False)
    contributions = db.Column(db.Float, nullable=False)
    balance = db.Column(db.Float, nullable=False)
    pension_type = db.Column(db.String(50), nullable=False)

    def to_dict(self):
        return {
            'id': self.id,
            'scheme_name': self.scheme_name,
            'contributions': self.contributions,
            'balance': self.balance,
            'pension_type': self.pension_type
        }