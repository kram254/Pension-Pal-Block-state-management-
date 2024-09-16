from app.models import Pension
from app import db

class PensionService:
    def get_all_pensions(self):
        return Pension.query.all()

    def get_pension_by_id(self, pension_id):
        return Pension.query.get(pension_id)

    def create_pension(self, data):
        required_fields = ['scheme_name', 'contributions', 'balance', 'pension_type']
        for field in required_fields:
            if field not in data:
                raise ValueError(f"Missing field: {field}")

        pension = Pension(
            scheme_name=data['scheme_name'],
            contributions=data['contributions'],
            balance=data['balance'],
            pension_type=data['pension_type']
        )
        db.session.add(pension)
        db.session.commit()
        return pension

    def update_pension(self, pension_id, data):
        pension = Pension.query.get(pension_id)
        if not pension:
            return None

        for key, value in data.items():
            if hasattr(pension, key):
                setattr(pension, key, value)
        
        db.session.commit()
        return pension

    def delete_pension(self, pension_id):
        pension = Pension.query.get(pension_id)
        if not pension:
            return False
        db.session.delete(pension)
        db.session.commit()
        return True